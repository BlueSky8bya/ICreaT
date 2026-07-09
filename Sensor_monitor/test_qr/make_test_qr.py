import json
import os

import qrcode

payload = json.dumps(
    {"stdy_no": "C250005", "subject_id": "121-001", "organ_cd": "121", "pat_name": "TEST"},
    ensure_ascii=False,
)
out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test_qr.png")
qrcode.make(payload).save(out)
print(payload)
print(out)
