from dataclasses import dataclass
from typing import List
import fitz  # PyMuPDF (https://pypi.org/project/PyMuPDF/)
import csv
from pathlib import Path
from contextlib import ExitStack

# Japanese convert (hiragana<>katakana<>kanji) - https://pypi.org/project/pykakasi/
import pykakasi
kks = pykakasi.kakasi()

doc_name = 'japanese-korean-chinese-common-words'
input_pdf_doc_path = Path().home() / 'Library' / 'CloudStorage' / 'Dropbox' / 'japanese' / f'{doc_name}.pdf'
output_csv_doc_path = Path().home() / 'Downloads' / f'{doc_name}.csv'

print(f'input PDF path : {input_pdf_doc_path} ---> output CSV path : {output_csv_doc_path}')


@dataclass
class AnkiCard:
    korean: str
    japanese: str


def convert_japanese_word(rawTxt):
    converted_japanese_words = kks.convert(rawTxt)
    full_converted_hiragana = ""
    full_converted_romaji = ""
    full_converted_orig = ""
    for word in converted_japanese_words: # should be only 1 word but if more simply append
        full_converted_orig += word['orig']
        full_converted_hiragana += word['hira']
        full_converted_romaji += word['hepburn'] # hepburn == Romanization/English
    full_converted = f"{full_converted_hiragana} ({full_converted_romaji}) {full_converted_orig}"
    print(f"converted Japanese --- {full_converted}")
    return full_converted

def isNonDataRow(blockLines):
    isTitle = (blockLines) and (len(blockLines) == 1)
    isHeading = (blockLines) and (len(blockLines) == 4) and (flattened_span_texts[0] == "No.")
    return (isTitle or isHeading)

allAnkiCards: List[AnkiCard] = []

# with ExitStack, open file objects are automatically closed when the with block is exited
with ExitStack() as stack:
    pdf_doc = stack.enter_context(fitz.open(input_pdf_doc_path))
    csv_doc = stack.enter_context(open(output_csv_doc_path, "w"))

    # Extract text from PDF
    for page_num in range(11, 17):  # PyMuPDF page numbers start at 0; adjust range as needed
        # Extract text from the page
        page = pdf_doc.load_page(page_num)
        page_text_dict = page.get_text("dict")
        for bIdx, block in enumerate(page_text_dict["blocks"]):
            blockLines = block["lines"] if (block and block["lines"]) else None
            if (not blockLines):
                continue

            # flatten list of list of spans
            from itertools import chain
            flattened_spans = list(chain.from_iterable([b["spans"] for b in blockLines]))
            # print(f"flattened_spans : {[s['text'] for s in flattened_spans]}")
            flattened_span_texts = [s["text"] for s in flattened_spans]
            # print(f"flattened_span_texts : {flattened_span_texts}")
            if (len(flattened_span_texts) == 5):
                # merge 3rd+4th spans into 3rd span
                flattened_span_texts = flattened_span_texts[:2] + [flattened_span_texts[2] + flattened_span_texts[3]] + flattened_span_texts[4:]
            # print(f"POST flattened_span_texts : {flattened_span_texts}")

            if (bIdx == 0) or isNonDataRow(blockLines):
                continue

            # Extract and convert words
            currAnkiCard = AnkiCard(korean=flattened_span_texts[1], japanese=convert_japanese_word(flattened_span_texts[3]))
            allAnkiCards.append(currAnkiCard)
        print(f"########### Page {page_num} done")

    # Write to CSV for Anki import (https://docs.ankiweb.net/importing/text-files.html)
    for ankiCard in allAnkiCards:
        print(ankiCard)
        writer = csv.writer(csv_doc)
        writer.writerow([ankiCard.korean, ankiCard.japanese])
    
    print(f"########### All done")
