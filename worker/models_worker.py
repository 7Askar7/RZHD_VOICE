import json
import traceback

from typing import Any
from models.transcribation import ModelTranscribation
from LLM_start import check_dialog

# Фиктивная функция get_session без базы данных
async def get_session():
    yield None

model = ModelTranscribation()

async def analyze_document(
    ctx: dict,
    class_name: str,
    doc_id: str,
    doc_name: str,
    **kwargs: Any,
):
    async for session in get_session():
        try:
            print("Start1")
            # Заглушка для данных, которые вы бы получали из базы данных
            data = doc_name
            # Моделируем работу вашей модели транскрибации
            tr = model.transcribe(data, doc_id)
            print("Start2")
            result_er = check_dialog(tr, "ЦД_35р_от_06_02_2024_контроль_регламента.pdf")
            lines = tr.split("\n")
            print("Start3")
            trans_lines = ["<Trans>" + line + "</Trans>" for line in lines]
            result_tr = "\n".join(trans_lines)
            print((result_tr, result_er))
            if not result_tr:
                raise Exception(f"Something is wrong. Try again later: {result_tr}")
            # Нет коммита, так как нет базы данных
            return result_tr
        except Exception as e:
            traceback.print_exc()
            return json.dumps({"data": doc_id, "result": str(e)})

async def main():
    ctx = {}  # Контекст
    class_name = "some_class_name"  # Обновите, если необходимо
    doc_id = None  # Установлено в None
    doc_name = "temp.mp3"  # Путь к вашему файлу
    result = await analyze_document(ctx, class_name, doc_id, doc_name)
    print("Результат:", result)

# Основная точка входа
if __name__ == "__main__":
    import nest_asyncio
    import asyncio

    nest_asyncio.apply()
    asyncio.run(main())
