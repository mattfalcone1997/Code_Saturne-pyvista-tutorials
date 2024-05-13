import gdown
import hashlib
import os

from zipfile import ZipFile


def main():

    # Get file from my personal google drive which contains dataset for use in this tutorial
    # Link can be found here: https://drive.google.com/file/d/11E0jUjsIMr1pehkZMr3Qt2wacMgO82g4/view?usp=drive_link

    # download zip file
    out = 'case.zip'
    zip_file_id = '11E0jUjsIMr1pehkZMr3Qt2wacMgO82g4'
    gdown.download(output=out,
                   id=zip_file_id)

    # Check sha256sum
    correct_hash = '47ffcec44a860a409bde60d6506fef11aa5347d76ff4a982f09b8137d400d7a2'
    with open(out, 'rb', buffering=0) as f:
        file_hash = hashlib.file_digest(f, 'sha256').hexdigest()

    if file_hash != correct_hash:
        raise Exception("Has of downloaded file does not match")

    # extract zip file
    with ZipFile(out, 'r') as zip:
        zip.extractall()

    os.remove(out)


if __name__ == '__main__':
    main()
