import json
from typing import Dict, Any

from sqlalchemy import select
from models.transcribation import ModelTranscribation
#from api.db_model import TransactionHistory, get_session, TransactionStatusEnum, Document
#from sqlalchemy.exc import NoResultFound
from models.transcribation.utils import FileProcessor
#from api.s3 import s3
import traceback


from LLM_start import check_dialog

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
            print("Start1")
            #data = await file_proc.process_file(doc_name, doc_id)
            data = doc_name
            tr = model.transcribe(data, doc_id)
            print("Start2")
            result_er = check_dialog(tr, "/home/jupyter/datasphere/project/ЦД_35р_от_06_02_2024_контроль_регламента.pdf")
            lines = tr.split("\n")
            print("Start3")
            trans_lines = ["<Trans>" + line + "</Trans>" for line in lines]
            result_tr = "\n".join(trans_lines)
            print("Start4")
            return (result_tr, result_er)
            if not result_tr:
                    raise Exception(f"Something is wrong. Try again later: {result_tr}")
            await session.commit()
            return result_tr
        except Exception as e:
            await session.commit()
            traceback.print_exc()
            return json.dumps({"data": doc_id, "result": str(e)})