"""Verify bundled shell archetypes without FiveM or guessed world placement.

The RSC7/Meta/CBaseArchetypeDef layouts are defined in CodeWalker.Core/GameFiles
(Resources/ResourceData.cs and MetaTypes/{Meta,MetaTypes}.cs). These are model
bounds only; CreateObject world placement is intentionally not inferred.
"""
import hashlib
import json
from pathlib import Path
import re
import struct
import sys
import zlib

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / 'docs/bundled-shell-bounds.json'

def joaat(name):
    value = 0
    for byte in name.lower().encode():
        value = (value + byte) & 0xffffffff
        value = (value + (value << 10)) & 0xffffffff
        value ^= value >> 6
    value = (value + (value << 3)) & 0xffffffff
    value ^= value >> 11
    return (value + (value << 15)) & 0xffffffff

def extract():
    asset = ROOT / 'stream/starter_shells_k4mb1.ytyp'
    raw = asset.read_bytes()
    assert raw[:4] == b'RSC7', 'Unsupported shell metadata container'
    data = zlib.decompress(raw[16:], -15)
    pointer = lambda value: value - 0x50000000
    block_start = pointer(struct.unpack_from('<Q', data, 48)[0])
    count = struct.unpack_from('<H', data, 76)[0]
    names = {joaat(path.stem): path.stem for path in (ROOT / 'stream').glob('*.ydr')}
    models = {}
    for index in range(count):
        kind, size, address = struct.unpack_from('<IIQ', data, block_start + 16 * index)
        if kind != 2195127427:  # CBaseArchetypeDef
            continue
        assert size % 144 == 0, 'Unexpected archetype size'
        for offset in range(pointer(address), pointer(address) + size, 144):
            model_hash = struct.unpack_from('<I', data, offset + 88)[0]
            asset_hash = struct.unpack_from('<I', data, offset + 112)[0]
            assert model_hash == asset_hash and model_hash in names, 'Unknown shell archetype/drawable'
            name = names[model_hash]
            low = struct.unpack_from('<3f', data, offset + 32)
            high = struct.unpack_from('<3f', data, offset + 48)
            assert all(a < b for a, b in zip(low, high)), 'Invalid authored bounds'
            models[name] = {'minimum': dict(zip('xyz', low)), 'maximum': dict(zip('xyz', high)),
                'sphereCenter': dict(zip('xyz', struct.unpack_from('<3f', data, offset + 64))),
                'sphereRadius': struct.unpack_from('<f', data, offset + 80)[0]}
    assert len(models) == 16, 'Bundled shell catalog changed; review geometry metadata'
    return {'asset': str(asset.relative_to(ROOT)), 'sha256': hashlib.sha256(raw).hexdigest(),
        'coordinates': 'model-local; not a CreateObject world transform', 'models': models}

if __name__ == '__main__':
    report = extract()
    if sys.argv[1:] == ['--update']:
        REPORT.parent.mkdir(exist_ok=True)
        REPORT.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    else:
        assert not sys.argv[1:], 'Only --update is supported'
        assert json.loads(REPORT.read_text()) == report, 'Bundled bounds report is stale'
        source = (ROOT / 'client/main.lua').read_text()
        factories = re.findall(r"(Create\w+)\s*=\s*\{ model = '([^']+)'", source)
        assert len(factories) == 16, 'Expected all sixteen bundled named shell factories'
        for factory, model in factories:
            assert model in report['models'], factory + ' points to an absent archetype'
        assert dict(factories)['CreateGarageMed'] == 'shell_garagem'
        assert dict(factories)['CreateFurniMotelStandard'] == 'standardmotel_shell'
        print('qbinterior bundled assets: 16 archetypes, factory models and exact bounds verified')
