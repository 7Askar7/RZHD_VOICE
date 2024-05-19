print("Start")
from unstructured.partition.pdf import partition_pdf
from unstructured.documents.elements import Table
import torch
from transformers import pipeline


def extract_reglament(file_path):
    elements = partition_pdf(file_path, languages=["ru"])

    table = [el.text for el in elements]

    flag = False
    all_text = ""
    for txt in table:
        if flag == False:
            if txt.startswith("Степень"):
                flag = True
                all_text += txt
        elif flag == True:
            all_text += txt 
            
    return all_text 


def model():
    loaded_model = pipeline("text-generation", 
                            model="openchat/openchat_3.5", 
                            torch_dtype=torch.bfloat16, 
                            device_map="cuda")
    return loaded_model

def check_dialog(problem, file_reglament):
    
    openchat = model()
    problem_chat = problem
    
    reglament = extract_reglament(file_reglament)
    verno = """
        Диспетчер: Машинист поезда 19 на 3-ем пути станции Заливное. 
        Машинист: Машинист поезда 19 на 3-м пути станции Заливное, Глошев. Слушаю вас.
        Диспетчер: Машинист поезда 19 Подтянули вплотную к сигналу Н-3?
        Машинист: Да, вплотную встали. Перекрывайте сигнал Н-3. Машинист Глошев.
        Диспетчер: Понятно, перекрываю сигнал Н-3
        Машинист: Прибытие 8:34
        Диспетчер: Понятно. Прибытие 8:34"""

    messages = [
        {
            "role": "system",
            "content": "Ты помогаешь определять ошибки в общении основываясь на регламенте и правильном диалоге."
        },
        {   "role": "user", 
            "content": f"""Задача: Определи ошибки в общение двух человек {problem_chat}. 
            Определи все ошибки на основе регламента {reglament} и примера верного диалога {verno}.
            Вывод в формате:        'Роль:
                                     Пример из диалога:
                                     Описание проблемы из регламента:'
            Степень не указывать."""
        },
    ]

    prompt = openchat.tokenizer.apply_chat_template(messages, 
                                                    tokenize=False, 
                                                    add_generation_prompt=True)

    outputs = openchat(prompt, 
                       max_new_tokens=800, 
                       do_sample=True, 
                       temperature=0.5, 
                       top_k=50, 
                       top_p=0.95)

    text = outputs[0]["generated_text"]
    parts = text.split("Assistant: ", 1)

    file_write = ""
    if len(parts) > 1:
        remaining_text = parts[1]
        lines = remaining_text.strip().split('\n')

        # Function to format a line into XML-like tags
        def format_line(line):
            if line.startswith('Роль: '):
                return f'<speech>{line}</speech>'
            elif line.startswith('Пример из диалога: '):
                return f'<error>{line}</error>'
            elif line.startswith('Описание проблемы из регламента: '):
                return f'<problem>{line}</problem>'
            else:
                return line

        # Format each line and join them back into a single string
        formatted_text = '\n'.join(format_line(line) for line in lines)

        file_write += formatted_text
    print(file_write)
    return file_write
