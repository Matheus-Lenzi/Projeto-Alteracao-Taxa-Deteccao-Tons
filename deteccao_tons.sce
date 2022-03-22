// Matheus Lenzi dos Santos - 19100420

// Definindo o algoritimo de Goertzel
function power = goertzelFilter(samples, freqs, SAMPLEFREQUENCY, N)
    s_prev = 0.0;
    s_prev2 = 0.0;
    coeff1=0; normalizedfreq=0; power=0; s=0;
    i=0;
    normalizedfreq = freqs / SAMPLEFREQUENCY;
    coeff1 = 2*cos(2*%pi*normalizedfreq);
    for i=1:N
        s = samples(i) + coeff1 * s_prev - s_prev2;
        s_prev2 = s_prev;
        s_prev = s;
    end
    power = s_prev2*s_prev2+s_prev*s_prev-coeff1*s_prev*s_prev2;
endfunction

// Indicando o caminho onde está salvo o áudio original no formato .wav
wave = "C:\Users\Matheus\Desktop\Projeto de Alteração de Taxa e Detecção de Tons\audio.wav";
wavread(wave,"Size")
wavread(wave,"Info")
// X -> Amplitude do som entre [-1, 1], com uma linha por canal de gravação
// Fs -> Frequência de amostragem em Hz
// bits -> Número de bits em X
[X,Fs,bits] = wavread(wave)

// Recuperando o tamanho do áudio original no formato .wav
wave_size = size(X)(2)

// Recuperando apenas um canal de gravação (Mono) áudio original
x = X(1,:)

// Calculando a FFT do sinal x
fft_x = abs(fft(x))

// Plotando a FFT do sinal x
subplot(2,1,1)
plot(fft_x)
xtitle("FFT de x")
xlabel('Frequência [Hz]')
ylabel('Magnitude')

// Adicionando o sinal cossenoidal no sinal original
A = max(abs(x));
tom = (A)*cos((%pi/7)*[1:10000]);
x_tom = [tom x];

// Calculando a FFT do sinal x com o tom
fft_x_tom = abs(fft(x_tom));

// Plotando a FFT do sinal x com o tom
subplot(2,1,2);
plot(fft_x_tom);
xtitle("FFT de x com o tom");
xlabel('Frequência [Hz]');
ylabel('Magnitude');

// Frequência para detecção
freqtonsrad = %pi/7;
freqtons = freqtonsrad*Fs/(2*%pi)

// Criando a janela
STEPW=2500;                     // Tamanho da janela
windowm = window('hm',STEPW);   // Janela de Hamming

TAM = size(x_tom)(2);
i = 1;
for n=1:STEPW:TAM - STEPW
    
    // Fazendo o janelamento
    x_tom_janelado = x_tom(n:n+STEPW - 1).*windowm;
    
    // Aplicando o algoritmo de Goertzel
    energyg(i) = goertzelFilter(x_tom_janelado, freqtons, Fs, STEPW);
    i = i + 1;
    disp(energyg)
end
