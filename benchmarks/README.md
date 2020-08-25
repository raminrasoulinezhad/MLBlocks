# selected benchmarks:

We have three set of benchmarks plus an extra total set:

1- CNNs: 

    + EfficientNet layers 
    + baidu benchmarks

2- LSTM: 

    + baidu benchmark - lstm kernels (DeepBenchmark)
    + HALP
    + Hebrue
    + Microsoft model 


3- DSP:  FIR, IIR, (excluding FFT) - source: ?
    
    + (maybe) ADASMark (some layers)
    

# potential benchmarks:

# DSP benchmarks: 
    
### ADASMark Benchmark (good but we wait for licence):

A full process of preprocessing and object detection  (complex but perfect)

    https://www.eembc.org/adasmark/

### UTDSP (1997):
FIR, LMS FIR, 
    
    https://www.eecg.utoronto.ca/~corinna/


    mm_benchmark_suite, 2001, https://people.eecs.berkeley.edu/~slingn/
    mm_benchmark_suite, 2001, https://people.eecs.berkeley.edu/~slingn/

    1997_benchmark_v1.0.tar.gz, 1997, http://groups.csail.mit.edu/cag/raw/benchmark/README.html


# LSTM benchmarks:

This paper helped me to fine the sources: 

    https://arxiv.org/pdf/1806.01818.pdf

Understanding of LSTM costs:

    https://pytorch.org/docs/stable/generated/torch.nn.LSTM.html
    https://pytorch.org/tutorials/beginner/nlp/sequence_models_tutorial.html

Computation:

concatanations: "|" horizental and "/" vertical

    [i/f/c/o] = ([[wiin/wfin/wcin/woin] | [wih/wfh/wch/woh]) * ([in/ht-1]) + [b/b/b/b]

#### cost:


without batch:

    [] = [[4h x in],[4h x h]]  x  [(in / h) x 1]
    [] = [4h x (in | h)]       x  [(in / h) x 1]

with batch:

    [] = [4h x (in | h)]       x  [(in / h) x B]

### DeepBench(great): 
baidu benchmark 

    (https://github.com/baidu-research/DeepBench)

### MLPerf (No good): 
    
GNMT model (big and complex)

    https://mlperf.org/inference-overview/#overview

GNMT Model:

    https://arxiv.org/pdf/1609.08144.pdf

code: 
    
    https://github.com/mlperf/inference/blob/master/v0.5/translation/gnmt/tensorflow/nmt/gnmt_model.py

### HALP (good):

26 char, 2LSTM (128node) FC26, 8bit

    https://www.cs.cornell.edu/~cdesa/papers/arxiv2018_lpsvrg.pdf
    https://arxiv.org/pdf/1803.03383.pdf


### Hebrue et al. (good):

RNN 1 hidden 2048, 3-4 bit
LSTM 1 hidden 300, 3-4 bit 

    https://catalog.ldc.upenn.edu/docs/LDC95T7/cl93.html
    https://www.jmlr.org/papers/volume18/16-456/16-456.pdf

### A google model (complex):

4 layers mixed of RNN and LSTM, 8 bit

    https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/45379.pdf


### Alibaba (ok)

quantized, sound detector, 

    ALTERNATINGMULTI-BITQUANTIZATION FORRECURRENTNEURALNETWORKS (https://arxiv.org/pdf/1802.00150.pdf)
    
### Microsoft LSTM network (easy):

2 separate LSTM50-->64,LSTM100-->64, FC128-->64 

    A Sentiment-and-Semantics-Based Approach for EmotionDetection in Textual Conversations (https://www.researchgate.net/publication/318671090_A_Sentiment-and-Semantics-Based_Approach_for_Emotion_Detection_in_Textual_Conversations?enrichId=rgreq-76d09f0b0a6b99e51e03b476603f55cc-XXX&enrichSource=Y292ZXJQYWdlOzMxODY3MTA5MDtBUzo1NjA2MTkyOTc4ODIxMTJAMTUxMDY3MzQ2NDU5NA%3D%3D&el=1_x_3&_esc=publicationCoverPdf)





