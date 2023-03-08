#define PCM_CODE        0x0001

typedef struct WaveChunk {
  char chunkID[4];  /* "RIFF" ASCII 0x52494646 big-endian form*/
  Uint32 chunkSize; /* ChunkSize 36 + SubChuk2Size = 4 + (8 + SubChunk1Size) +
                       (8 + SubChunk2Size) */
  char format[4];   /* Contains the letters "WAVE" 0x57415645 big-endian form */
} WaveChunk;

typedef struct WaveFormat {
  char subchunk1ID[4];  /* Contains the letters "fmt " (0x666d7420 big-endian
                           form).*/
  Uint32 subchunk1Size; /* 16 for PCM. This is the size of the rest of the
                           Subchunk which follows this number.*/
  Uint16 audioFormat;   /* PCM = 1 (i.e. Linear quantization) */
  Uint16 numChannels;   /* Mono = 1, Stereo = 2, etc. */
  Uint32 sampleRate;    /* 8000, 44100, etc. */
  Uint32 byteRate;      /* == SampleRate * NumChannels * BitsPerSample/8 */
  Uint16 blockAlign;    /* == NumChannels * BitsPerSample/8 */
  Uint16 bitsPerSample; /* 8 bits = 8, 16 bits = 16, etc. */
} WaveFormat;

typedef struct WaveData {
  char subchunk2ID[4];  /* Contains the letters "data" (0x64617461 big-endian
                           form). */
  Uint32 subchunk2Size; /* == NumSamples * NumChannels * BitsPerSample/8  */
} WaveData;

typedef struct WaveFile {
  WaveChunk chunk;

  WaveFormat format;

  WaveData data;
} WaveFile;
