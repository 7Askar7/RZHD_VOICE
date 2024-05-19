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
<Trans>SPEAKER_00: 2675 или Бежесибирская красавица.</Trans>
<Trans>SPEAKER_01: 2-6-0-7-6-5, машина из Генбельска, на 2-4-3-4-ком в километре, слушаю.</Trans>
<Trans>SPEAKER_00: Машинец, здравствуйте, поездной диспетчер, впереди полностью перегон свободен. Пожалуйста, максимальную скорость выдерживать надо 6.08, за вами еще куча-куча поездов.</Trans>
<Trans>SPEAKER_01: Две шестьсот семьдесят пять, и начнёт геймплейский. Понятно, скорость максимально выдерживаем, шесть ноль восемь градусов, за нами куча проездов.</Trans>
<Trans>SPEAKER_00: Верно. Стараемся, пожалуйста, в 6.08 пройти.</Trans>
<Trans></Trans>
            """

            # Analyze

            # result_er = check_dialog(tr, "/home/jupyter/datasphere/project/ЦД_35р_от_06_02_2024_контроль_регламента.pdf")
            result_er = """
<speech>Роль: SPEAKER_00</speech>
<error>Ошибка из диалога: Бежесибирская красавица.</error>
<problem>Описание проблемы из регламента: Неупотребление установленных форм (сокращение установленных форм).</problem>

<speech>Роль: SPEAKER_00</speech>
<error>Ошибка из диалога: 2675</error>
<problem>Описание проблемы из регламента: Неупотребление установленных форм (сокращение установленных форм).</problem>

<speech>Роль: SPEAKER_01</speech>
<error>Ошибка из диалога: 2-6-0-7-6-5, машина из Генбельска, на 2-4-3-4-ком в километре, слушаю.</error>
<problem>Описание проблемы из регламента: Непередача показаний светофоров по маршруту следования (неупотребление установленных форм).</problem>

<speech>Роль: SPEAKER_00</speech>
<error>Ошибка из диалога: Машинец, здравствуйте, поездной диспетчер, впереди полностью перегон свободен. Пожалуйста, максимальную скорость выдерживать надо 6.08, за вами еще куча-куча поездов.</error>
<problem>Описание проблемы из регламента: Неубеждение в правильности восприятия команды (недостаточная четкость).</problem>

<speech>Роль: SPEAKER_01</speech>
<error>Ошибка из диалога: Две шестьсот семьдесят пять, и начнёт геймплейский. Понятно, скорость максимально выдерживаем, шесть ноль восемь градусов, за нами куча проездов.</error>
<problem>Описание проблемы из регламента: Неубеждение в правильности восприятия команды (недостаточная четкость).</problem>

<speech>Роль: SPEAKER_00</speech>
<error>Ошибка из диалога: Верно. Стараемся, пожалуйста, в 6.08 пройти.</error>
<problem>Описание проблемы из регламента: Неубеждение в правильности восприятия команды (недостаточная четкость).</problem>

<speech>Роль: SPEAKER_01</speech>
<error>Ошибка из диалога: Получилось 6.08.</error>
<problem>Описание проблемы из регламента: Неупотребление установленных форм (сокращение установленных форм).</problem>
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
                doc.any_error_reason = f"Found errors by analyze model:\n TestExplanetion"
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