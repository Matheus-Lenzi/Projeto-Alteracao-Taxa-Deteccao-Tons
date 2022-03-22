// Matheus Lenzi dos Santos - 19100420

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
subplot(3,1,1)
plot(fft_x)
xtitle("FFT de x")
xlabel('Frequência [Hz]')
ylabel('Magnitude')

// Definindo o fator de redução/aumento de taxa
N = 2

// Filtrando o sinal por filtro passa-baixas e janela de Hamming
filtro = wfir('lp', 100, [1/(2*N) 0], 'hm', [0 0])
x_filtrado = filter(filtro, [1], x)

// Reduzindo a taxa pelo fator N
z = x_filtrado(1:N:wave_size)
wave_size_z = size(z)(2)

// Calculando a FFT do sinal z
fft_z = abs(fft(z))

// Plotando a FFT do sinal z
subplot(3,1,2)
plot(fft_z)
xtitle("FFT de z")
xlabel('Frequência [Hz]')
ylabel('Magnitude')

// Aumentando a taxa pelo fator N
y = zeros(N*wave_size_z);
for n = 1:wave_size_z
    y(N*n) = z(n)
end

// Filtrando o sinal por filtro passa-baixas e janela de Hamming
filtro = wfir('lp', 100, [1/(2*N) 0], 'hm', [0 0])
y_filtrado = filter(filtro, [1], y)

// Calculando a FFT do sinal y
fft_y = abs(fft(y_filtrado))

// Plotando a FFT do sinal y
subplot(3,1,3)
plot(fft_y)
xtitle("FFT de y")
xlabel('Frequência [Hz]')
ylabel('Magnitude')
