"""
Arabic Translation Library for Robot Framework
Simple transliteration from English to Arabic
"""

def translate_to_arabic(english_text):
    """
    Simple English to Arabic transliteration
    For proper translation, use Google Translate API
    """
    # Basic transliteration mapping
    transliteration = {
        'a': 'ا', 'b': 'ب', 'c': 'ك', 'd': 'د', 'e': 'ي',
        'f': 'ف', 'g': 'ج', 'h': 'ه', 'i': 'ي', 'j': 'ج',
        'k': 'ك', 'l': 'ل', 'm': 'م', 'n': 'ن', 'o': 'و',
        'p': 'ب', 'q': 'ق', 'r': 'ر', 's': 'س', 't': 'ت',
        'u': 'و', 'v': 'ف', 'w': 'و', 'x': 'كس', 'y': 'ي',
        'z': 'ز', ' ': ' '
    }
    
    arabic_text = ''
    for char in english_text.lower():
        arabic_text += transliteration.get(char, char)
    
    return arabic_text
