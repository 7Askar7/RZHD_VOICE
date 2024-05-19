import os
from api.s3 import s3

class FileProcessor:
    def __init__(self):
        self.s3_client = s3

    async def process_file(self, filename: str, file_id: str, check_extansion: bool=True):
        # Определение типа файла по расширению
        extension = filename.split('.')[-1].lower()
        if check_extansion and extension not in ["mp3", "wav", "opus", "oga", "flac", "webm", "weba", "ogg", "m4a", "mid", "amr", "aiff", "wma", "au", "aac"]:
            raise Exception(f"Unexpected file type: {extension}")
        
        new_filename = file_id+filename
        # Скачивание файла
        file_data = await self.s3_client.download_file(file_id)
        with open(new_filename, 'wb') as f:
            f.write(file_data)
        return new_filename
    
    def clear_temp_file(self, new_filename):
        if os.path.exists(new_filename):
            os.remove(new_filename)