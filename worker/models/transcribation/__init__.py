from pyannote.audio import Pipeline
import pandas as pd
from faster_whisper import WhisperModel
import os
import soundfile as sf
import librosa.display
from pydub import AudioSegment
from pyannote.audio.pipelines.utils.hook import ProgressHook



class ModelTranscribation:
    def __init__(
        self,
        model_name: str = "pyannote/speaker-diarization-3.0",
        use_auth_token="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",
        device: str = "cuda",
    ):
        self.pipeline = Pipeline.from_pretrained(model_name, use_auth_token)
        self.transcribe_model = WhisperModel("large-v3", device="cuda")
        #self.device = device
        #self.model.to(device)

    def read_rttm(self, file_path: str):
        rttm_data = pd.read_csv(file_path, delimiter=' ', header=None, names=['type', 'file_id', 'channel', 'tbeg', 'tdur', 'ortho', 'stype', 'name', 'conf', 'stime'])
        return rttm_data

    def prepare_audio(self, output_file: str):
        audio = AudioSegment.from_file(f"{output_file}.wav", format="wav")
        rttm_data = self.read_rttm(f"{output_file}.rttm")
        result = ""
        # Разделение аудио по спикерам
        i = 0
        for _, row in rttm_data.iterrows():
                speaker = row['name']
                start = row['tbeg']
                end = start + row['tdur']
                start_ms = start * 1000
                end_ms = end * 1000
                i += 1
                segment = audio[start_ms:end_ms]
                segment.export(f"{output_file}_{speaker}_{i}.wav", format="wav")
                y, sr = librosa.load(f"{output_file}_{speaker}_{i}.wav")
                y_normalized = librosa.util.normalize(y)
                sf.write(f"{output_file}_{speaker}_{i}.wav", y_normalized, sr)
                segments, info = self.transcribe_model.transcribe(f"{output_file}_{speaker}_{i}.wav", beam_size=10, vad_filter=True, language='ru')
                os.remove(f"{output_file}_{speaker}_{i}.wav")
                res = ""
                for segment in segments:
                    res += segment.text
                if res:
                    result += speaker + ": " + res.strip() + "\n"
        if result:
            with open(output_file+".txt", 'w', encoding="utf-8") as out:
                out.write(result)
                out.close()
            return result
        else:
            return None


    def transcribe(self, audio_file: str, id: str):
        # Конвертация в WAV моно-канал
        file_extension = os.path.splitext(audio_file)[1]
        format = file_extension[1:].lower()
        output_file = os.path.splitext(os.path.basename(audio_file))[0]
        audio = AudioSegment.from_file(audio_file, format=format)
        if format == "wav":
            audio_mono = audio
        else:
            audio_mono = audio.set_channels(1)
            
        audio_mono = audio_mono + 15
        audio_mono.export(output_file+".wav", format="wav")

        y, sr = librosa.load(output_file+".wav")
        y_normalized = librosa.util.normalize(y)
        sf.write(output_file+".wav", y_normalized, sr)
        diarization = self.pipeline(output_file+".wav", num_speakers=2)
        
        with open(f"{output_file}.rttm", "w") as rttm:
            diarization.write_rttm(rttm)
        result = self.prepare_audio(output_file)
        os.remove(output_file+".wav")
        os.remove(output_file+".rttm")
        return result