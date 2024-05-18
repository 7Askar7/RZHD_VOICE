#from api.s3 import s3
#from PyPDF2 import PdfReader
#from docx import Document
#import openpyxl

class FileProcessor:
    def __init__(self):
        self.s3_client = s3

    async def process_file(self, filename: str, file_id: str):
        # Определение типа файла по расширению
        extension = filename.split('.')[-1].lower()
        if extension not in ["mp3", "wav", "opus", "oga", "flac", "webm", "weba", "ogg", "m4a", "mid", "amr", "aiff", "wma", "au", "aac"]:
            raise Exception(f"Unexpected file type: {extension}")

        # Скачивание файла
        file_data = await self.s3_client.download_file(file_id)
        return filename