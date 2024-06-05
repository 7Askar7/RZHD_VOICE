import json
from typing import Dict, Any

from sqlalchemy import select
from worker.models.transcribation import ModelTranscribation
from api.db_model import TransactionHistory, get_session, TransactionStatusEnum, Document
from sqlalchemy.exc import NoResultFound
from worker.models.transcribation.utils import FileProcessor
from api.s3 import s3
import traceback

model = ModelTranscribation()
file_proc = FileProcessor()


async def analyze_document(
    ctx: Dict[str, Any],
    class_name: str,
    doc_id : str,
    doc_name: str,
    **kwargs: Any,
):
    async for session in get_session():
        try:
            data = await file_proc.process_file(doc_name, doc_id)
            
            tr = model.transcribe(data, doc_id)
            lines = tr.split("\n")
            trans_lines = ["<Trans>" + line + "</Trans>" for line in lines]
            result_tr = "\n".join(trans_lines)
            return (result_tr, result_er)
            if not result_tr:
                raise Exception(f"Something is wrong. Try again later: {result_tr}")
            await session.commit()
            return result_tr
        except Exception as e:
            await session.commit()
            traceback.print_exc()
            return json.dumps({"data": doc_id, "result": str(e)})
