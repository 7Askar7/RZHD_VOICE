import json
from typing import Dict, Any
import traceback

from sqlalchemy import select
# from worker.models.transcribation import ModelTranscribation
from worker.models.utils import FileProcessor

from api.db_model import TransactionHistory, get_session, TransactionStatusEnum, Document
#from sqlalchemy.exc import NoResultFound
#from api.s3 import s3
import traceback


# from LLM_start import check_dialog

# model = ModelTranscribation()
file_proc = FileProcessor()


async def analyze_document(
    ctx: Dict[str, Any],
    doc_id : str,
    doc_name: str,
    **kwargs: Any,
):
    async for session in get_session():
        doc = await session.execute(
            select(Document).filter_by(id=doc_id)
        )
        doc = doc.scalar()
        new_filename = ""
        try:
            job_id = ctx.get("job_id", None)
            if not job_id:
                raise Exception("Something is wrong. job_id is None")

            transaction = await session.execute(
                select(TransactionHistory).filter_by(job_id=job_id)
            )
            transaction = transaction.scalar()
            
            # Transcribe 

            new_filename = await file_proc.process_file(doc_name, doc_id, check_extansion=False)
            # tr = model.transcribe(data, doc_id)
            # lines = tr.split("\n")
            # trans_lines = ["<Trans>" + line + "</Trans>" for line in lines]
            # result_tr = "\n".join(trans_lines)
            result_tr = """
<Trans>SPEAKER_00: 2-6-7-5 или даже Сибирская Красава?</Trans>
<Trans>SPEAKER_01: Держу 275, машине Эдген Белькинович, 440 в километре, слушаю.</Trans>
<Trans>SPEAKER_00: Машине здравствуйте, поездной диспетчер. Впереди полностью перегон свободен. Пожалуйста, максимальную скорость выдерживать надо 6.08. За вами еще куча-куча поездов.</Trans>
<Trans>SPEAKER_01: 2680 на Шнергенбиске. Понятно, скорость максимально выдерживаем, 608 градцев, а за нами куча проездов.</Trans>
<Trans>SPEAKER_00: Верно. Стараемся, пожалуйста, 6.08 пройти.</Trans>
            """

            # Analyze

            # result_er = check_dialog(tr, "/home/jupyter/datasphere/project/ЦД_35р_от_06_02_2024_контроль_регламента.pdf")
            result_er = """
<speech>Роль: SPEAKER_00</speech>
<error>Ошибки из диалога: Ош`ибочное написание "2-6-7-5" вместо "275" и "Сибирская Красава"</error>
<problem>Проблема из регламента: Сокращение установленных форм</problem>

<speech>Роль: SPEAKER_01</speech>
<error>Ошибки из диалога: Неуказание места нахождения руководителя маневров при движении маневрового состава вагонами вперед</error>
<problem>Проблема из регламента: Нарушение руководителем маневров периодичности сообщений машинисту при движении вагонами вперед</problem>

<speech>Роль: SPEAKER_00</speech>
<error>Ошибки из диалога: Нет</error>
<problem>Проблема из регламента: Нет</problem>

<speech>Роль: SPEAKER_01</speech>
<error>Ошибки из диалога: Нет</error>
<problem>Проблема из регламента: Нет</problem>`
            """

            # if not result_tr:
            #     raise Exception(f"Something is wrong. Try again later: {result_tr}")


            # TODO: results processing 
            any_err = False
            # TODO: Определить наличие ошибок
            if result_tr:
                any_err = True
            
            if any_err:
                doc.any_error_verified = False
                doc.any_error_reason = f"Found errors by analyze model:\n{result_tr}"
            else:
                doc.any_error_verified = True
                doc.any_error_reason = f"Not found errors by analyze model"
            
            transaction.status = TransactionStatusEnum.SUCCESS
            result = {"result_tr": result_tr, "result_er": result_er, "any_err": doc.any_error_verified, "any_error_reason": doc.any_error_reason}

            json_data = json.dumps({"doc_id": doc_id, "result": result})
            transaction.result = json_data
            await session.commit()

            # Clear temp file arter processing
            file_proc.clear_temp_file(new_filename)
            
            return result
        except Exception as e:
            transaction.status = TransactionStatusEnum.FAILURE
            transaction.err_reason = str(e)
            doc.any_error_verified = False
            doc.any_error_reason = f"File processing error: {e}"
            await session.commit()
            # Clear temp file arter processing
            file_proc.clear_temp_file(new_filename)
            traceback.print_exc()
            return json.dumps({"doc_id": doc_id, "result": str(e)})