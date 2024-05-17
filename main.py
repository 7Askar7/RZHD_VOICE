from pydub import AudioSegment
import pandas as pd
import os
import soundfile as sf
import librosa.display
from faster_whisper import WhisperModel

import torch
from pyannote.audio import Pipeline


def read_rttm(file_path):
    rttm_data = pd.read_csv(file_path, delimiter=' ', header=None, names=['type', 'file_id', 'channel', 'tbeg', 'tdur', 'ortho', 'stype', 'name', 'conf', 'stime'])
    return rttm_data


def prepare_audio():
    audio = AudioSegment.from_file("output_audio.wav", format="wav")
    model_size = "large-v3"
    model = WhisperModel(model_size, device="cuda", compute_type="float16")
    rttm_data = read_rttm("audio.rttm")
    results = []
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
        segment.export(f"result/{speaker}_{i}.wav", format="wav")

        y, sr = librosa.load(f"result/{speaker}_{i}.wav")
        y_normalized = librosa.util.normalize(y)
        sf.write(f"result/{speaker}_{i}.wav", y_normalized, sr)

        segments, info = model.transcribe(f"result/{speaker}_{i}.wav", beam_size=10, vad_filter=True, language='ru')
        os.remove(f"result/{speaker}_{i}.wav")
        res = ""
        for segment in segments:
            res += segment.text
        if res != "" and "Продолжение следует..." not in res and "Субтитры сделал DimaTorzok" not in res and "До новых встреч!" in res:
            result_dict = {
                "speaker": speaker,
                "text": res.strip()
            }
            results.append(result_dict)

    with open("results.json", "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)


def app(path):
    pipeline = SpeakerDiarization.from_pretrained(
        "pyannote/speaker-diarization-3.1",
        use_auth_token="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")
    pipeline.to(torch.device("cuda"))
    
    # Конвертация в WAV 1 канал
    input_file = path
    output_file = "output_audio.wav"
    
    _, file_extension = os.path.splitext(input_file)
    format = file_extension[1:].lower()  # Get the lowercase file extension
    
    audio = AudioSegment.from_file(input_file, format=format)
    
    if format == "wav":
        audio_mono = audio
    else:
        audio_mono = audio.set_channels(1)
    
    audio_mono.export(output_file, format="wav")
    
    with ProgressHook() as hook:
        diarization = pipeline(output_file, hook=hook, num_speakers=2)
    
    with open("audio.rttm", "w") as rttm:
        diarization.write_rttm(rttm)

    prepare_audio()
