#!/bin/bash

cd .. && cp -r zfp zfpV4 && cd zfpV4

sed -i -- 's/zfpV5/zfpV4/g' src/CMakeLists.txt
grep -rl 'V5' ./include | xargs sed -i 's/V5/V4/g'
grep -rl 'v5' ./include | xargs sed -i 's/v5/v4/g'

# replace constants
grep -rl 'define ZFP_V4_VERSION_MINOR' ./include | xargs sed -i -- 's/define ZFP_V4_VERSION_MINOR 5/define ZFP_V4_VERSION_MINOR 4/g'
grep -rl 'define ZFP_V4_VERSION_PATCH' ./include | xargs sed -i -- 's/define ZFP_V4_VERSION_PATCH 2/define ZFP_V4_VERSION_PATCH 1/g'
grep -rl 'define ZFP_V4_CODEC' ./include | xargs sed -i -- 's/define ZFP_V4_CODEC 5/define ZFP_V4_CODEC 4/g'

# modify compressor/decompressor behavior (for 2d)
perl -pe 's{const Scalar\* data = field->data;}{++$n == 3 ? "const Scalar\* data = field->data; stream_write_bit(stream->stream, 0);" : $&}ge' src/template/compress.c > src/template/compress2.c
perl -pe 's{Scalar\* data = field->data;}{++$n == 3 ? "Scalar\* data = field->data; stream_read_bit(stream->stream);" : $&}ge' src/template/decompress.c > src/template/decompress2.c
mv src/template/compress2.c src/template/compress.c
mv src/template/decompress2.c src/template/decompress.c
