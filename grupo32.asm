; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Grupo nº 32
; *
; * Elementos:
; *     Iulian Puscasu          87665
; *     Ricardo Caetano         87699
; *     Martim Leite            87684
; *
; *********************************************************************

; *********************************************************************
; * Constantes
; *********************************************************************
;--------------------- Valores alteráveis -----------------------------

LIM_ESQ       EQU 0       ; nº do pixel que limita a área de jogo, á esquerda
LIM_DIR       EQU 12      ; nº do pixel que limita a área de jogo, á direita
INI_C         EQU 5       ; coluna em que aparece a peça inicial

LEFT          EQU 0       ; tecla que faz o tetramino mover para a esquerda
RIGHT         EQU 2       ; tecla que faz o tetramino mover para a direita
DOWN          EQU 1       ; tecla que faz o tetramino mover para baixo
ROTATE        EQU 3       ; tecla que faz o tetramino rodar
SPEED         EQU 7       ; tecla que altera a velocidade do jogo

START         EQU 4       ; tecla que inicia o jogo
PAUSE         EQU 5       ; tecla que pausa o jogo
RESET         EQU 6       ; tecla que reinicia o jogo

SPEED1        EQU 1       ; número de ciclos de relógio necessários para mover um tetraminó
SPEED2        EQU 3       ; alterna-se entre estes valores para alterar a velocidade do jogo
                          ; recomenda-se baixar o periodo do clock para uma melhor experiência

DELAY         EQU 1FFH    ; tamanho do delay para as peças em modo de queda rápida

COMPLETE_LINE EQU 5       ; quantidade de pontos ganha com uma linha completa
KILL_MONSTER  EQU 2       ; quantidade de pontos ganha por matar o monstro
TARGET        EQU 99      ; pontuação necessária para ganhar o jogo

PROB_M        EQU 4       ; valor pelo qual se faz resto da divisão inteira da variável aleatória
                          ; quanto mais baixo, maior a probabilidade de aparecer o monstro

;--------------------- Valores não alteráveis -------------------------

TECLA         EQU 0F50H    ; onde se guarda o valor da tecla premida
FALL          EQU 0F52H    ; onde se guarda a variável que a interrupção0 muda para o tetraminó mover para baixo
MAX_INDEX     EQU 0F54H    ; onde se guarda (nº de possibilidades para um tetramino aleatório * 2)
MIN_INDEX     EQU 2        ; onde se guarda o indice mais baixo possivel para aceder á tabela de tabelas de tetraminós

CURRENT_S     EQU 0F56H    ; onde se guarda a velocidade atual do jogo (nº de ciclos de relógio por peça)
CONTADOR_R    EQU 0F58H    ; onde se guarda o contador de ciclos de relógio

FIRST_T_TABLE EQU 0F60H    ; onde se guarda endereço da primeira tabela do tetraminó atual
LAST_T_TABLE  EQU 0F62H    ; onde se guarda endereço da primeira tabela que não pertence ao tetraminó atual

CURRENT_C     EQU 0F64H    ; onde se guarda nº da coluna do tetramino que está a ser controlado
CURRENT_L     EQU 0F66H    ; onde se guarda nº da linha do tetramino que está a ser controlado
CURRENT_T     EQU 0F68H    ; onde se guarda endereço da tabela do tetramino que está a ser controlado

LAST_C        EQU 0F6AH    ; onde se guarda nº da coluna anterior do tetramino que está a ser controlado
LAST_L        EQU 0F6CH    ; onde se guarda nº da linha anterior do tetramino que está a ser controlado
LAST_T        EQU 0F6EH    ; onde se guarda endereço da tabela anterior do tetramino que está a ser controlado

INI           EQU 8       ; posição inicial do bit correspondente à linha a testar
NULL          EQU 0       ; valor nulo utilizado para fazer reset
EMPTY         EQU 0       ; valor que aparece no display de sete segmentos quando não há uma tecla premida
LIM_SCREEN    EQU 32      ; nº limite de pixels do ecra
DEZ           EQU 10      ; número 10, utilizado para calcular os digitos da pontuação
BY_LINHA      EQU 4       ; número de bytes de uma linha do ecrã
MONSTRO_SEP1  EQU 2       ; número pixels sobrepostos entre o separador do ecrã e a coluna mais á esquerda do monstro
MONSTRO_SEP2  EQU 1       ; número pixels sobrepostos entre o separador do ecrã e a coluna do meio do monstro
L_COMP        EQU 4       ; número de vezes que se verifica se há uma linha completa

PAUSE_MODE    EQU 0F70H    ; onde se guarda o estado do jogo(0- pausado, 1- nao pausado)
GAME_STATE    EQU 0F72H    ; onde se guarda o estado do jogo(0- parado, 1- em progresso)
FIRST_MOVE    EQU 0F74H    ; endereço cuja variável é 1 quando é a primeira jogada, fica a 0 a partir dai
BOTTOM        EQU 0F76H    ; endereço cuja variávél é 1 quando se chega ao fundo do ecrã
SCORE         EQU 0F78H    ; endereço onde se guarda a pontuação
H_SCORE       EQU 0F7AH    ; endereço onde se guarda a pontuação máxima atingida

LAST_LINE     EQU 0F7CH    ; endereço onde se guarda o endereço da figura 1x18

LINHA_M       EQU 0F80H    ; onde se guarda nº da linha atual do monstro
COLUNA_M      EQU 0F82H    ; onde se guarda nº da coluna atual do monstro
LINHA_INI     EQU 17       ; linha onde o monstro se movimenta (linha do canto superior esquerdo)
EXISTE_M      EQU 0F84H    ; endereço cuja variável é 1 quando o monstro existe e 0 quando não existe
TABELA_M      EQU 0F86H    ; onde se guarda a tabela com a informação do monstro
MOVE_M        EQU 0F88H    ; onde se guarda a variável que a interrupção1 muda para o monstro mover para a esquerda

ENTRADA_T     EQU 0C000H
SAIDA_T       EQU 0E000H  ; endereços de entrada e saída dos perifericos do teclado

ENTRADA_D     EQU 0A000H  ; endereço de entrada dos displays de sete segmentos

SCREEN        EQU 8000H   ; endereço do ecrã


; *********************************************************************
; * Inicializações gerais
; *********************************************************************
PLACE       2000H

pointer:    TABLE  100H         ; tabela do stack pointer
pointer_fim:

interruptions:
    WORD    interrup0       ; tabela de vectores de interrupção
    WORD    interrup1

mascaras:
    STRING  80H, 40H, 20H, 10H, 8H, 4H, 2H, 1H        ; utilizadas para isolar pixels do ecrã

mascara_teclado:
    STRING  15              ; mascara com os quatro bits da direita a 1, equivale a FH

linha1x18:
    STRING  18, 1
    STRING  1, 1, 1, 1, 1, 1, 1, 1, 1         ; linha com comprimento máximo da área de jogo
    STRING  1, 1, 1, 1, 1, 1, 1, 1, 1         ; utilizada para verificar se há uma linha completa

monstro_drawing:
    STRING  3, 3
    STRING  1, 0, 1             ; tabela utilizada para desenhar o monstro
    STRING  0, 1, 0             ; primeiro elemento- nº de colunas, segundo elemento- nº de linhas
    STRING  1, 0, 1             ; resto dos elementos- 1 para pixels a escrever, 0 para pixeis a ignorar

separador_repair:
    STRING  1, 4
    STRING  1, 1, 1, 1    ; figura desenhada em cima do separador para o reparar depois de o monstro passar por cima

;--------------------- Tabelas com posições de texto -------------------------
pause_location:
    STRING  26, 19          ; linha e coluna do sinal de pausa

text_message_location:
    STRING  14, 0

hud_location:                  ; (os números têm duas colunas, um para cada digito)
    STRING  0, 18              ; linha, coluna
    STRING  6, 20              ; linha, coluna
    STRING  12, 24, 28         ; linha, coluna, coluna
    STRING  20, 20             ; linha, coluna
    STRING  26, 24, 28         ; linha, coluna, coluna

;--------------------- Tabelas tetraminós -----------------------------
tetramino1_1:           ; primeiro elemento- nº de colunas, segundo elemento- nº de linhas
    STRING  2, 3        ; resto dos elementos- 1 para pixels a escrever, 0 para pixeis a ignorar
    STRING  1, 0        ; x
    STRING  1, 1        ; xx
    STRING  1, 0        ; x

tetramino1_2:
    STRING  3, 2
    STRING  0, 1, 0      ;  x
    STRING  1, 1, 1      ; xxx

tetramino1_3:
    STRING  2, 3
    STRING  0, 1         ;  x
    STRING  1, 1         ; xx
    STRING  0, 1         ;  x

tetramino1_4:
    STRING  3, 2
    STRING  1, 1, 1        ; xxx
    STRING  0, 1, 0        ;  x 

tetramino2_1:
    STRING  1, 4
    STRING  1          ; x
    STRING  1          ; x
    STRING  1          ; x
    STRING  1          ; x

tetramino2_2:
    STRING  4, 1
    STRING  1, 1, 1, 1     ; xxxx

tetramino3_1:
    STRING  2, 2
    STRING  1, 1        ; xx
    STRING  1, 1        ; xx

tetramino4_1:
    STRING 2, 3
    STRING 1, 0         ; x
    STRING 1, 0         ; x
    STRING 1, 1         ; xx

tetramino4_2:
    STRING 3, 2
    STRING 0, 0, 1         ;   x
    STRING 1, 1, 1         ; xxx
 
tetramino4_3:
    STRING 2, 3
    STRING 1, 1         ; xx
    STRING 0, 1         ;  x
    STRING 0, 1         ;  x

tetramino4_4:
    STRING 3, 2
    STRING 1, 1, 1         ; xxx
    STRING 1, 0, 0         ; x

tetramino5_1:
    STRING 2, 3
    STRING 0, 1         ;  x
    STRING 1, 1         ; xx
    STRING 1, 0         ; x

tetramino5_2:
    STRING 3, 2
    STRING 1, 1, 0        ; xx
    STRING 0, 1, 1        ;  xx

tetramino6_1:
    STRING 2, 3
    STRING 0, 1         ;  x
    STRING 0, 1         ;  x
    STRING 1, 1         ; xx

tetramino6_2:
    STRING 3, 2
    STRING 1, 1, 1        ; xxx
    STRING 0, 0, 1        ;   x
 
tetramino6_3:
    STRING 2, 3
    STRING 1, 1           ; xx
    STRING 1, 0           ; x
    STRING 1, 0           ; x

tetramino6_4:
    STRING 3, 2
    STRING 1, 0, 0        ; x
    STRING 1, 1, 1        ; xxx

tetramino7_1:
    STRING 2, 3
    STRING 1, 0          ; x
    STRING 1, 1          ; xx
    STRING 0, 1          ;  x

tetramino7_2:
   STRING 3, 2
   STRING 0, 1, 1         ;  xx
   STRING 1, 1, 0         ; xx
ultimo_tetramino:

tetraminos:
    WORD  tetramino1_1      ; tabela com endereços de todos os tetraminos
    WORD  tetramino2_1
    WORD  tetramino3_1
    WORD  tetramino4_1
    WORD  tetramino5_1
    WORD  tetramino6_1
    WORD  tetramino7_1
tetraminos_fim:

;--------------------- Tabelas digitos -----------------------------
digito0:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 1, 0, 1          ; daqui para a frente estão as tabelas para escrever todos os digitos
    STRING 1, 0, 1
    STRING 1, 0, 1
    STRING 1, 1, 1

digito1:
    STRING 3, 5
    STRING 0, 0, 1
    STRING 0, 0, 1
    STRING 0, 0, 1
    STRING 0, 0, 1
    STRING 0, 0, 1

digito2:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 0, 0, 1
    STRING 0, 1, 0
    STRING 1, 0, 0
    STRING 1, 1, 1

digito3:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 0, 0, 1
    STRING 0, 1, 1
    STRING 0, 0, 1
    STRING 1, 1, 1

digito4:
    STRING 3, 5
    STRING 1, 0, 1
    STRING 1, 0, 1
    STRING 1, 1, 1
    STRING 0, 0, 1
    STRING 0, 0, 1

digito5:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 1, 0, 0
    STRING 1, 1, 1
    STRING 0, 0, 1
    STRING 1, 1, 1

digito6:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 1, 0, 0
    STRING 1, 1, 1
    STRING 1, 0, 1
    STRING 1, 1, 1

digito7:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 0, 0, 1
    STRING 0, 0, 1
    STRING 0, 1, 0
    STRING 0, 1, 0

digito8:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 1, 0, 1
    STRING 1, 1, 1
    STRING 1, 0, 1
    STRING 1, 1, 1

digito9:
    STRING 3, 5
    STRING 1, 1, 1
    STRING 1, 0, 1
    STRING 1, 1, 1
    STRING 0, 0, 1
    STRING 0, 0, 1

digitos:
    WORD    digito0             ; tabela com os endereços das tabelas dos digitos
    WORD    digito1
    WORD    digito2
    WORD    digito3
    WORD    digito4
    WORD    digito5
    WORD    digito6
    WORD    digito7
    WORD    digito8
    WORD    digito9

;--------------------- Tabelas para texto -----------------------------
hit_start:                 ; texto mostrado no inicio do jogo
    STRING 31, 5
    STRING 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1
    STRING 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0
    STRING 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0
    STRING 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0
    STRING 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0

you_win:                 ; texto mostrado quando o jogo é ganho, com a mensagem 'you win'
    STRING 28, 5
    STRING 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1
    STRING 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1
    STRING 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1
    STRING 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1
    STRING 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1

game_over:               ; texto mostrado quando o jogo é perdido, com a mensagem 'game over'
    STRING 32, 5
    STRING 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1
    STRING 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1
    STRING 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0
    STRING 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1
    STRING 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1

score:
    STRING 11, 5
    STRING 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1          ; pixels que formam a palavra 'score' em 'high score'
    STRING 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1
    STRING 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0
    STRING 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1
    STRING 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1

high:
    STRING 13, 5
    STRING 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1         ; forma a palavra 'high' em 'high score'
    STRING 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1
    STRING 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1
    STRING 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
    STRING 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1

paused:
    STRING 3, 5
    STRING 1, 0, 1          ; duas linhas paralelas que representam o jogo em pausa, aparece assim que o jogo pausa
    STRING 1, 0, 1
    STRING 1, 0, 1
    STRING 1, 0, 1
    STRING 1, 0, 1


;--------------------- Stack pointer e interrupções -----------------------------
PLACE       0

start:
    MOV  SP, pointer_fim      ; inicializa stack pointer

    MOV  BTE, interruptions     ; incializa BTE

    EI0                    ; permite interrupções 0 e 1
    EI1
    EI 

;--------------------- Reset de todos os valores utilizados -----------------------------
    CALL reset_everything


; *********************************************************************
; * Variáveis globais
; *********************************************************************
    MOV  R11, 0        ; R11 é 0 quando nenhuma tecla é premida e 1 quando há uma tecla premida
    MOV  R10, 2        ; varia entre 2 e (total de tetraminos * 2), dá um tetramino aleatório
    MOV  R9, 0         ; R9 é 1 quando há um tetramino manipulável no ecrâ e 0 quando não há
    MOV  R8, 1         ; R8 a 1 dá permissão para alterar a posição do tetraminó, sem interrupções 
    MOV  R7, 0         ; R7 está a 1 quando a queda livre está ativada
    MOV  R6, 1         ; R6 a 1 dá permissão para interromper o jogo (pausa)
    MOV  R5, 0         ; dá permissão para mover uma peça para baixo (interrupçâo)
                                                                                        ;###
                                                                                      ;###
; *********************************************************************             ;###    ############
; * Código principal                                                                  ;###
; *********************************************************************                 ;###
main_loop:

    CALL  gerador
    CALL  keyboard
    CALL  control

    MOV   R1, PAUSE_MODE
    MOVB  R0, [R1]
    CMP   R0, 0         ; verifica se o jogo está em pausa
    JZ    main_loop

    CALL  tetramino

    CALL  monstro

    JMP   main_loop


; *********************************************************************
; * Rotinas de interrupção
; *********************************************************************

interrup0:
    PUSH  R1
    PUSH  R5

    MOV  R1, FALL
    MOV  R5, 1
    MOV  [R1], R5       ; permite a queda de uma peça

    POP  R5
    POP  R1
    RFE

interrup1:
    PUSH  R1
    PUSH  R5

    MOV  R1, MOVE_M
    MOV  R5, 1
    MOVB [R1], R5       ; permite movimento do monstro

    POP  R5
    POP  R1
    RFE


; *********************************************************************
; * Rotinas chamadas pelo programa principal
; *********************************************************************

; *********************************************************************
; * Descrição - Repõe os valores iniciais a registos, memória e periféricos
; * Recebe    - nada
; * Devolve   - todos os registos a 0
; *********************************************************************
reset_everything:
    CALL  empty_hex_display      ; limpa os displays hexadecimais
    CALL  calc_max_index         ; calcula o indice máximo para um tetraminó, dependendo de quantos deles há
    CALL  reset_monstro          ; põe o monstro na posição mais á direita possivel

    MOV   R8, hit_start          ; endereço da mensagem a mostrar no ecrã inicial
    CALL  blank_screen           ; limpa o ecrã

    MOV  R1, PAUSE_MODE
    MOV  R3, 0
    MOVB  [R1], R3              ; reinicia variáveis em memória com os seus valores iniciais

    MOV  R1, GAME_STATE
    MOV  R3, 0
    MOVB [R1], R3

    MOV  R1, FIRST_MOVE
    MOV  R3, 1
    MOVB [R1], R3

    MOV  R1, LAST_LINE
    MOV  R2, linha1x18
    MOV  [R1], R2

    MOV  R1, LINHA_M
    MOV  R2, LINHA_INI
    MOVB [R1], R2

    MOV  R1, EXISTE_M
    MOV  R2, 0
    MOVB [R1], R2

    MOV  R1, TABELA_M
    MOV  R2, monstro_drawing
    MOV  [R1], R2

    MOV  R1, CURRENT_S
    MOV  R2, SPEED1
    MOVB [R1], R2

    MOV  R1, CONTADOR_R
    MOV  R2, SPEED1
    MOVB [R1], R2

    MOV  R1, BOTTOM
    MOV  R4, 0
    MOV  [R1], R4

    MOV  R1, SCORE
    MOV  R2, 0
    MOV  [R1], R2

    MOV  R1, H_SCORE
    MOV  R2, 0
    MOV  [R1], R2

    MOV R0, 0
    MOV R1, 0
    MOV R2, 0
    MOV R3, 0
    MOV R4, 0
    MOV R5, 0           ; reinicia todos os registos a 0
    MOV R6, 0
    MOV R7, 0
    MOV R8, 0
    MOV R9, 0
    MOV R10, 0
    MOV R11, 0

    RET


; *********************************************************************
; * Descrição - escreve um valor nulo (EMPTY) no display 
; * Recebe    - nada
; * Devolve   - nada
; *********************************************************************
empty_hex_display:
    PUSH  R1
    PUSH  R2

    MOV   R1, ENTRADA_D     ; R1 com o endereço dos displays
    MOV   R2, EMPTY
    MOVB  [R1], R2

    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Cria um delay no programa,
; *             sendo a duração dependente do valor recebido
; * Recebe    - R5, endereço de memória com duração do delay
; * Devolve   - nada
; *********************************************************************
delay:
    PUSH R5

delay_ciclo:
    SUB  R5, 1
    JNZ  delay_ciclo

    POP  R5
    RET


; *********************************************************************
; * Descrição - Faz o acesso a um teclado (Push Matrix).
; *             Detecta e guarda em memória a tecla premida
; * Recebe    - nada
; * Devolve   - o valor da tecla premida, em memória, no endereço TECLA
; *      notas: Pode alterar variáveis globais R11, R8, R6
; *             Quando uma tecla deixa de ser premida:
; *               R11 passa a 0
; *               R8 passa a 1
; *               R6 passa a 1
; *********************************************************************
keyboard:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R7
    PUSH  R9
    PUSH  R10

    CALL  read_keys
    AND   R2, R2            ; afecta as flags, R2 é o nº da coluna
    JZ    restart_key_read

    CMP   R11, 1            ; enquanto a mesma tecla continuar a ser premida r11 é diferente de 0
    JZ    return_from_keyb    ; volta ao ciclo até que a tecla deixe de ser premida

    MOV   R10, R1
    CALL  key_conversion
    MOV   R7, R9            ; armazena a linha em R7

    MOV   R10, R2
    CALL  key_conversion        
    MOV   R4, R9            ; armazena a coluna em R4

    CALL  calculate_key

    CALL  save_key
    MOV   R11, 1             ; guarda o facto de que uma tecla foi escrita

    JMP   return_from_keyb

restart_key_read:
    CMP   R11, 1            ; verifica se havia uma tecla premida no ciclo anterior
    JNZ   return_from_keyb                      

    MOV   R11, 0                ; registo passa a zero quando nenhuma tecla está a ser premida
    MOV   R8, 1                 ; dá permissão para mover o tetraminó
    MOV   R6, 1                 ; dá permissão para o jogo ser interrompido

    MOV   R0, TECLA
    MOV   [R0], R11             ; variável da tecla em memória passa a 0

return_from_keyb:
    POP  R10
    POP  R9
    POP  R7
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Percorre as 4 linhas do teclado á procura de teclas premidas e
; *             devolve a linha e coluna de uma tecla, se for premida
; *             Se nenhuma tecla for premida devolve coluna com valor 0
; * Recebe    - nada
; * Devolve   - R1, linha em binário
; *           - R2, coluna em binário
; *********************************************************************
read_keys:
    PUSH  R3
    PUSH  R4

    MOV   R1, INI

    MOV   R3, mascara_teclado
    MOVB  R4, [R3]

cycle_read_keys:
    MOV   R3, ENTRADA_T
    MOVB  [R3], R1        ; escrever no periférico de entrada do teclado

    MOV   R3, SAIDA_T
    MOVB  R2, [R3]        ; ler do periférico de saída do teclado

    AND   R2, R4            ; afectar as flags (MOVs não afectam as flags)
    JNZ   return_input      ; tecla premida

next_line:
    SHR   R1, 1             ; se nenhuma tecla foi premida passa á próxima linha do teclado
    CMP   R1, 0
    JZ    return_input

    JMP   cycle_read_keys

return_input:
    POP  R4
    POP   R3
    RET


; *********************************************************************
; * Descrição - Converte um numero em binário para valor decimal
; * Recebe    - R10, valor em binário
; * Devolve   - R9, valor de R10 convertido para decimal
; *********************************************************************
key_conversion:
    MOV  R9, NULL                ; reset do registo que conta a linha na rotina seguinte
    PUSH R10

cycle_convert:
    CMP  R10, 1                  ; verifica se o bit de menor peso é 1

    JZ   equals_one              ; quando o bit de menor peso for 1, passa á funḉão seguinte

    SHR  R10, 1                  ; divide o número da linha (em binário) por 2
    ADD  R9, 1                   ; armazena o número da linha em decimal (de 0 a 4) em R8

    JMP  cycle_convert

equals_one:
    POP  R10
    RET


; *********************************************************************
; * Descrição - Calcula o valor da tecla
; * Recebe    - R7, valor da linha em decimal
; *           - R4, valor da coluna em decimal
; * Devolve   - R7, valor da tecla
; *********************************************************************
calculate_key:
    PUSH R6

    MOV  R6, 4
    MUL  R7, R6             ; multiplica o numero da linha por 4
    ADD  R7, R4             ; adiciona ao resultado anterior o numero da coluna

    POP  R6
    RET


; *********************************************************************
; * Descrição - guarda em memória o valor da tecla premida, a partir do endereço com valor TECLA
; *             também muda o valor mostrado nos displays para o da tecla premida
; * Recebe    - R0, endereço no qual escreve o valor da tecla
; *           - R7, valor da tecla
; * Devolve   - nada
; *********************************************************************
save_key:
    PUSH  R3
    PUSH  R0

    MOV   R0, TECLA
    MOVB  [R0], R7          ; guarda o valor da tecla em memória

    POP   R0
    POP   R3
    RET


; *********************************************************************
; * Descrição - Atualiza o valor mostrado nos displays para a pontuação atual
; * Recebe    - nada
; * Devolve   - nada
; *********************************************************************
update_hex_display:
    PUSH R2
    PUSH R3
    PUSH R6
    PUSH R7

    MOV  R6, SCORE
    MOVB R7, [R6]          ; pontuação em R7 e R3
    MOV  R3, R7

    MOV  R6, DEZ
    MOD  R7, R6            ; R7 com digito das unidades

    DIV  R3, R6
    MOV  R2, 16            ; multiplica por 16 para passar de base hex para decimal
    MUL  R3, R2            ; R3 com digito das unidades

    ADD  R7, R3

    MOV  R2, ENTRADA_D
    MOVB [R2], R7          ; escreve o valor atual da pontuação nos displays

    POP  R7
    POP  R6
    POP  R3
    POP  R2
    RET


; *********************************************************************
; * Descrição - Faz reset do ecra, deixando apenas a linha separadora
; * Recebe    - LIM_DIR, limite direito da área de jogo
; * Devolve   - nada
; *********************************************************************
clear_screen:
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R6
    PUSH  R7

    MOV  R1, 0      ; nº da linha (0-31)
    MOV  R2, 0      ; nº da coluna (0-31)
    MOV  R3, 0      ; R3 determina se escreve (a 1) ou apaga o pixel (a 0)

    MOV  R6, LIM_DIR       ; coluna em que se escreve a linha separadora
    MOV  R7, LIM_SCREEN    ; limites do ecra

ciclo_sep:
    CALL draw_pixel

    ADD  R2, 1      ; proxima coluna

    CMP  R3, 1      
    JNZ  teste_separador
    MOV  R3, 0      ; muda a variavel para apagar um pixel

teste_separador:
    CMP  R2, R6     ; compara a coluna atual com a do separador
    JNZ  teste_limites

    MOV  R3, 1      ; se for a linha correta, deixa escrever um pixel

teste_limites:
    CMP  R2, R7      ; verifica se está dentro dos limites
    JNZ  ciclo_sep

    MOV  R2, 0      ; se chegou á ultima coluna, passa ao inicio da próxima linha
    ADD  R1, 1

    CMP  R1, R7      ; verifica se está dentro dos limites
    JZ   fim_ciclo_sep

    JMP  ciclo_sep
    
fim_ciclo_sep:
    POP  R7
    POP  R6
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Limpa o ecrã totalmente, deixando tudo em branco
; * Recebe    - nada
; * Devolve   - nada
; *********************************************************************
clear_all:
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R6
    PUSH  R7

    MOV  R1, 0      ; nº da linha (0-31)
    MOV  R2, 0      ; nº da coluna (0-31)
    MOV  R3, 0      ; R3 determina se escreve (a 1) ou apaga o pixel (a 0)

    MOV  R7, LIM_SCREEN    ; limites do ecra

clear_next:
    CALL draw_pixel

    ADD  R2, 1      ; proxima coluna
    CMP  R2, R7      ; verifica se está dentro dos limites das colunas
    JNZ  clear_next

    MOV  R2, 0      ; se chegou á ultima coluna, passa ao inicio da próxima linha
    ADD  R1, 1
    CMP  R1, R7      ; verifica se está dentro dos limites das linhas
    JZ   clear_end

    JMP  clear_next
    
clear_end:
    POP  R7
    POP  R6
    POP  R3
    POP  R2
    POP  R1
    RET
    

; *********************************************************************
; * Descrição - escreve ou apaga um pixel no ecra
; * Recebe    - R1, linha a escrever o pixel
; *           - R2, coluna a escrever o pixel
; *           - R3, 1 para escrever um pixel, 0 para apagar um pixel
; * Devolve   - nada
; *********************************************************************
draw_pixel:
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R8
    PUSH  R9

    MOV  R5, SCREEN     ; endereço com que se acede o pixelscreen

    MOV  R9, R2         ; faz uma copia do r2 (coluna)

    MOV  R8, 4
    MUL  R1, R8         ; multiplica linha por 4

    MOV  R8, 8
    DIV  R2, R8         ; divisao inteira de coluna por 8

    ADD  R1, R2     
    ADD  R5, R1         ; byte do ecra a escrever

    MOV  R4, mascaras
    MOD  R9, R8         ; resto da divisao da coluna por 8
    ADD  R4, R9         ; vai-se encontrar o indice da mascara necessaria
    MOVB R9, [R4]       ; valor da mascara

    CMP  R3, 1
    JNZ  bit_a_0        ; determina qual a operação necessária

bit_a_1:
    MOVB R1, [R5]       ; move o byte atual do ecra para R1
    OR   R9, R1

    JMP  escrever_bit

bit_a_0:
    MOVB R1, [R5]       ; move o byte atual do ecra para R1
    NOT  R9
    AND  R9, R1

escrever_bit:
    MOVB [R5], R9       ; escreve o bit desejado, tendo em conta o byte existente

    POP  R9
    POP  R8
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - escreve ou apaga um tetramino no ecra
; * Recebe    - R6, linha do canto superior esquerdo do tetramino
; *           - R7, coluna do canto superior esquerdo do tetramino
; *           - R8, tetramino desejado (endereço da tabela com a sua informação)
; *           - R5, 1 para escrever, 0 para apagar
; * Devolve   - nada
; *********************************************************************
draw_tetramino:
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6
    PUSH  R7
    PUSH  R8
    PUSH  R9
    PUSH  R10
    PUSH  R11

    MOVB  R9, [R8]      ; R9 com comprimento do tetramino
    ADD  R8, 1
    MOVB  R10, [R8]     ; R10 com altura do tetramino

    MOV  R4, 0          ; contador de nº de colunas escritas
    MOV  R11, 0         ; contador de nº de linhas escritas

next_table_value:
    ADD  R8, 1          ; passa ao próximo elemento da tabela
    MOVB  R3, [R8]      ; R3 com o elemento que é 0 ou 1, para escrever ou não um pixel

    CMP  R3, 1          ; verifica se tem de escrever um pixel
    JNZ  go_to_next_square    ; se não escreve neste pixel, vai passar ao próximo

    CMP  R5, 0          ; se vai alterar pixel, verifica se é escrever ou apagar
    JNZ  change_square

    MOV  R3, 0      ; R3 é um parametro da rotina que escreve pixels, fica a 0 para apagar o pixel

change_square:
    MOV  R1, R6         ; linha a escrever
    MOV  R2, R7         ; coluna a escrever
    CALL draw_pixel

go_to_next_square:
    ADD  R7, 1          ; próxima coluna
    ADD  R4, 1          ; contador para colunas aumenta

    CMP  R4, R9         ; verifica se contador chegou ao limite (comprimento)
    JNZ  next_table_value

    SUB  R7, R9         ; quando chega ao limite, volta á coluna mais á esquerda
    MOV  R4, 0          ; reinicia contador para colunas
    ADD  R6, 1          ; passa á próxima linha
    ADD  R11, 1         ; contador para linhas aumenta

    CMP  R11, R10       ; verifica se chegou á última linha
    JZ   end_drawing

    JMP  next_table_value

end_drawing:
    POP  R11
    POP  R10
    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - calcula o indice máximo para a lista de endereços de tetraminos
; * Recebe    - nada
; * Devolve   - o valor calculado, armazenado na variável em memória com endereço MAX_INDEX
; *********************************************************************
calc_max_index:
    PUSH R4
    PUSH R5
    PUSH R7

    MOV  R4, tetraminos             ; tetraminos é a lista com os endereços dos tetraminos possiveis
    MOV  R5, tetraminos_fim         ; tetraminos_fim é o fim da lista
    SUB  R5, R4

    MOV  R7, MAX_INDEX
    MOVB [R7], R5                   ; MAX_INDEX fica com (nº de endereços de tetraminos * 2)

    POP  R7
    POP  R5
    POP  R4
    RET


; *********************************************************************
; * Descrição - Cria e modifica a variável global R10
; * Recebe    - nada
; * Devolve   - R10, um valor aleatório
; *      notas: R10 varia entre 2 e o valor em memória de MAX_INDEX
; *             R10 é decrescente
; *********************************************************************
gerador:
    PUSH  R2
    PUSH  R7

    SUB  R10, MIN_INDEX     ; MIN_INDEX é o indice mais baixo possivel com que se pode aceder á tabela de tabelas de tetraminós
    MOV  R2, 0
    CMP  R10, R2            ; verifica se R10 é igual ao primeiro valor abaixo do minimo
    JNZ  numero_gerado

    MOV  R7, MAX_INDEX
    MOVB R2, [R7]           ; R2 é o indice máximo para a lista de endereços de tetraminós
    MOV  R10, R2            ; quando passa do limite volta ao valor máximo

numero_gerado:
    POP  R7
    POP  R2
    RET


; *********************************************************************
; * Descrição - Trata de tudo a ver com tetraminós (criação, movimento, colisão)
; * Recebe    - TECLA, endereço com valor da tecla premida
; * Devolve   - nada
; *********************************************************************
tetramino:
    PUSH R0
    PUSH R10
    
    CALL draw_random_tetramino     ; Gera o tetraminó inicial aleatório
    CMP  R1, 1                     ; verifica se o jogo já acabou
    JZ   dont_change_tetramino

    CALL change_coordinates        ; Altera a posição do tetraminó
    CALL tetramino_update          ; Desenha os tetraminós á medida que vão mudando de posição

    CMP  R9, 0
    JNZ  dont_change_tetramino

    MOV  R0, L_COMP              ; contador iniciado a 4

check_line_again:
    CALL check_complete_line        ; verifica se uma linha está completa, 4 vezes
                                    ; 4 linhas é o máximo que se pode fazer de uma vez
    CMP  R10, 1                     ; verifica se a rotina apagou uma linha
    JNZ  dont_change_tetramino      ; se não apagou uma, não vale a pena ver 4

    SUB  R0, 1
    JNZ  check_line_again

dont_change_tetramino:
    POP  R10
    POP  R0
    RET


; *********************************************************************
; * Descrição - Desenha um tetramino aleatório no topo do ecrâ
; * Recebe    - nada
; * Devolve   - R1, fica a 1 se o jogo acabou
; *      notas: Utiliza e altera variável global R9 e R10
; *********************************************************************
draw_random_tetramino:
    PUSH  R0
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6
    PUSH  R7
    PUSH  R8

    MOV  R1, 0          ; o valor a retornar inicia com valor 0

    CMP  R9, 1              ; se já há um tetraminó controlável, não vai criar outro
    JZ  nao_gera

    MOV  R1, BOTTOM
    MOV  R4, 0
    MOV  [R1], R4           ; já não está na última linha do ecrã

    MOV  R5, 1              ; R5 a 1 para escrever e não apagar
    MOV  R6, 0              ; linha 0
    MOV  R7, INI_C          ; coluna 5

    MOV  R3, tetraminos_fim  ; R3 com o endereço do fim da lista de tetraminos
    SUB  R3, R10             ; R10 varia entre 2 e (total de tetraminos * 2)
    MOV  R8, [R3]            ; R8 com a tabela de um tetraminó aleatório

    CALL save_new_coordinates

    MOV  R3, R6
    MOV  R4, R7
    MOV  R1, CURRENT_T        ; converte os argumentos para os registos que a próxima rotina utiliza
    CALL check_for_pieces

    CMP  R0, 0
    JZ  continua_jogo       ; verifica se há uma peça em cima da posição inicial

    CALL reset
    MOV  R8, game_over      ; texto mostrado no fim do jogo
    CALL blank_screen       ; quando há uma peça em cima da posição inicial, o jogo acaba
    MOV  R1, 1              ; ativa a flag a dizer que o jogo acabou
    JMP  nao_gera

continua_jogo:
    CALL draw_tetramino

nao_gera:
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R0
    RET


; *********************************************************************
; * Descrição - Guarda em memória as coordenadas e caracteristicas do novo tetraminó
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Pode passar R10 (valor aleatório) para o seu próximo valor
; *             R9 é 1 quando há um tetramino controlável no ecrâ, é 0 para o oposto
; *             Endereços de memória alterados:
; *               CURRENT_L
; *               CURRENT_C
; *               CURRENT_T
; *               LAST_L
; *               LAST_C
; *               LAST_T
; *               LAST_T_TABLE
; *               FIRST_T_TABLE
; *             Os valores destes endereços são alterados de acordo com as caracteristicas do tetraminó gerado
; *********************************************************************
save_new_coordinates:
    PUSH  R0
    PUSH  R3
    PUSH  R6
    PUSH  R7
    PUSH  R8

    MOV  R0, CURRENT_L
    MOVB [R0], R6            ; guarda a linha em memória

    MOV  R0, LAST_L
    MOVB [R0], R6            ; guarda a linha em memória

    MOV  R0, CURRENT_C
    MOVB [R0], R7            ; guarda a coluna em memória

    MOV  R0, LAST_C
    MOVB [R0], R7            ; guarda a coluna em memória

    MOV  R0, CURRENT_T
    MOV  [R0], R8             ; guarda qual o tetramino em memória

    MOV  R0, LAST_T
    MOV  [R0], R8             ; guarda qual o tetramino em memória

    MOV  R0, FIRST_T_TABLE
    MOV  [R0], R8             ; guarda qual a primeira tabela deste tetraminó

    CMP  R10, MIN_INDEX       ; se o indice deste tetraminó for o menor possivel, o próximo tetraminó é o inicial
    JNZ  proximo_indice

    MOV  R8, ultimo_tetramino   ; no caso do tetraminó no último indice, não há uma tabela a seguir á dele
    JMP  update_last_table

proximo_indice:
    CALL gerador             ; passa ao próximo indice da tabela de tetraminós

    MOV  R3, tetraminos_fim  ; R3 com o endereço do fim da lista de tetraminos
    SUB  R3, R10             ; R10 varia entre 2 e (total de tetraminos * 2)
    MOV  R8, [R3]            ; R8 com a tabela do primeiro tetraminó diferente do atual

update_last_table:
    MOV  R0, LAST_T_TABLE
    MOV [R0], R8             ; guarda qual a primeira tabela que não pertence a este tetraminó

    MOV  R9, 1               ; R9 não vai permitir escrever outro tetramino enquanto estiver ativo

    POP  R8
    POP  R7
    POP  R6
    POP  R3
    POP  R0
    RET


; *********************************************************************
; * Descrição - Verifica se há uma tecla premida. Se o valor da tecla premida 
; *             corresponder a uma das teclas que podem movimentar o tetraminó, altera 
; *             as suas coordenadas de acordo com o movimento correspondente
; *             Também pode alterar a velocidade do jogo
; * Recebe    - R7, variável global. Se estiver ativada, o tetraminó move sempre para baixo
; *           - R8, verifica se tem permissão (só é dada quando se pára de carregar na mesma tecla)
; *           - R5, se estiver ativada move uma linha para baixo
; * Devolve   - nada
; *      notas: Pode alterar variáveis em memória:
; *               CONTADOR_R, contador de ciclos de relógio
; *             Quando o tetraminó chega ao fundo, muda R9 para 0
; *********************************************************************
change_coordinates:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6
    PUSH  R10
    PUSH  R11

    CMP  R7, 1            ; R7 é 1 quando o modo de queda está ativado
    JZ   modo_queda

    CMP  R11, 1         ; verifica se há alguma tecla premida
    JNZ  check_fall

    CMP  R8, 1          ; verifica se tem permissão (só é dada quando se pára de carregar na mesma tecla)
    JNZ  check_fall

    MOV  R1, TECLA      ; R1 com endereço da tecla
    MOVB R0, [R1]       ; R0 com o valor da tecla

check_left:
    CMP  R0, LEFT         ; verifica se a tecla é a que move o tetraminó para a esquerda
    JNZ  check_right

    CALL move_left
    JMP  nao_move_mais

check_right:
    CMP  R0, RIGHT         ; verifica se a tecla é a que move o tetraminó para a direita
    JNZ  check_rotate

    CALL move_right
    JMP  nao_move_mais

check_rotate:
    CMP  R0, ROTATE         ; verifica se é a tecla que roda o tetraminó
    JNZ  check_speed

    CALL tetramino_rotate
    JMP  nao_move_mais

check_speed:
    CMP  R0, SPEED         ; verifica se é a tecla que altera a velocidade do jogo
    JNZ  check_down

    CALL change_speed
    JMP  nao_move_mais

check_down:
    CMP  R0, DOWN         ; verifica se a tecla é a que move o tetraminó para o fundo
    JNZ  check_fall

    MOV  R7, 1            ; modo queda livre ativado

modo_queda:
    MOV  R5, DELAY        ; delay utilizado para que a queda do tetraminó não seja demasiado rápida
    CALL delay
    CALL move_down

    JMP  nao_move_mais

check_fall:
    MOV  R1, FALL
    MOV  R5, [R1]
    CMP  R5, 1          ; verifica se é necessário mover para baixo
    JNZ  nao_move_mais

    MOV  R2, CONTADOR_R
    MOVB R3, [R2]          ; R3 com quantidade de ciclos de relógio até poder mexer a peça para baixo

    CMP  R3, 1             ; se o contador for maior que 1 ciclo, não move a peça para baixo
    JNZ  skip_cycle

    MOV  R4, CURRENT_S
    MOVB R3, [R4]
    MOVB [R2], R3       ; quando o contador chega a 0, volta ao seu valor inicial (CURRENT_S)

    CALL move_down
    MOV  R5, 0          ; só quando a interrupçao voltar a pôr FALL a 1 é que volta a mover para baixo
    MOV  [R1], R5

    JMP  nao_move_mais

skip_cycle:
    SUB  R3, 1
    MOV  R2, CONTADOR_R
    MOVB [R2], R3         ; decrementa o contador e guarda o seu valor

    MOV  R1, FALL
    MOV  R5, 0
    MOV  [R1], R5       ; desactiva a flag que permite a queda de uma peça

nao_move_mais:
    POP  R11
    POP  R10
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Altera as coordenadas do tetraminó a ser controlado 1 pixel para a esquerda, 
; *             verificando se está dentro do limite da área de jogo
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               CURRENT_C, com a coluna atual do tetramino
; *********************************************************************
move_left:
    PUSH R0
    PUSH R2
    PUSH R3

    MOV  R2, CURRENT_C
    MOVB R3, [R2]         ; R3 com o nº da coluna atual

    MOV  R0, LIM_ESQ      ; R0 com nº do pixel do limite esquerdo do ecra
    CMP  R3, R0           ; compara o novo valor com o limite
    JZ   dont_move_left

    SUB  R3, 1            ; move uma coluna para a esquerda
    MOVB [R2], R3         ; guarda o novo valor de CURRENT_C (coluna)

    MOV  R8, 0            ; não permite mais alterações

dont_move_left:
    POP  R3
    POP  R2
    POP  R0
    RET


; *********************************************************************
; * Descrição - Altera as coordenadas do tetraminó a ser controlado 1 pixel para a direita, 
; *             verificando se está dentro do limite da área de jogo
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               CURRENT_C, com a coluna atual do tetramino
; *********************************************************************
move_right:
    PUSH R0
    PUSH R2
    PUSH R3
    PUSH R4

    MOV  R2, CURRENT_C
    MOVB R3, [R2]         ; R3 com o valor da coluna atual
    ADD  R3, 1            ; move uma coluna para a direita

    MOV  R1, CURRENT_T
    MOV  R4, [R1]         ; R4 com endereço da tabela do tetraminó

    MOVB R1, [R4]         ; R1 com comprimento do tetraminó
    ADD  R1, R3           ; soma da coluna atual com o comprimento 
    SUB  R1, 1            ; menos uma coluna que se sobrepõe

    MOV  R0, LIM_DIR      ; R0 com nº do pixel do limite direito do ecra
    CMP  R1, R0           ; compara o total com o limite
    JZ   dont_move_right

    MOVB [R2], R3         ; guarda o novo valor de CURRENT_C (coluna)

    MOV  R8, 0            ; não permite mais alterações

dont_move_right:
    POP  R4
    POP  R3
    POP  R2
    POP  R0
    RET


; *********************************************************************
; * Descrição - Altera a variável em memória que controla a velocidade
; *             A velocidade é controlada alterando o número de interrupções 
; *             necessárias para que um tetraminó se mova
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               CURRENT_S, número de interrupções necessárias para que uma peça se mova
; *********************************************************************
change_speed:
    PUSH R2
    PUSH R3
    PUSH R4

    MOV  R2, CURRENT_S
    MOVB R3, [R2]         ; R3 com o valor da velocidade atual

    MOV  R4, SPEED1
    CMP  R3, R4
    JNZ  change_to_speed1  ; verifica se a velocidade é igual a SPEED1

    MOV  R4, SPEED2
    MOVB [R2], R4          ; se for igual, altera a velocidade para SPEED2

    JMP  speed_change_end

change_to_speed1:
    MOVB [R2], R4          ; se não for igual, altera a velocidade para SPEED1
    
speed_change_end:
    MOV  R8, 0            ; não permite mais alterações

    POP  R4
    POP  R3
    POP  R2
    RET


; *********************************************************************
; * Descrição - Faz o tetraminó cair 1 linha para baixo
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Verifica se já chegou ao fundo
; *             Depois de chegar ao fundo ainda permite um movimento
; *             Altera variáveis em memória:
; *               CURRENT_L, com a linha atual do tetramino
; *             Quando chega ao fundo, altera variáveis globais R7 e R9 para 0
; *********************************************************************
move_down:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    MOV  R2, CURRENT_L
    MOVB R3, [R2]         ; R3 com o valor da linha atual

    MOV  R1, BOTTOM
    MOV  R4, [R1]
    CMP  R4, 1          ; verifica se a flag que diz que está no fundo do ecrã está ativada
    JNZ  not_in_the_bottom

    MOV  R7, 0          ; desactiva a queda livre
    MOV  R9, 0          ; já não há um tetraminó controlável no ecrã
    JMP  proxima_linha

not_in_the_bottom:
    ADD  R3, 1            ; move uma linha para baixo

    MOV  R1, CURRENT_T
    MOV  R4, [R1]         ; R4 com endereço da tabela do tetraminó
    ADD  R4, 1            ; passa ao próximo elemento da tabela

    MOVB R1, [R4]         ; R1 com altura do tetraminó
    ADD  R1, R3           ; soma da linha atual com a altura 
    SUB  R1, 1            ; menos uma linha que se sobrepõe

    MOV  R0, LIM_SCREEN     ; R0 com nº de pixels até ao limite inferior do ecrã
    SUB  R0, 1              ; menos um que se sobrepõe
    CMP  R1, R0             ; compara o total com o limite
    JNZ  proxima_linha

    MOV  R1, FALL       ; FALL é a variável que a interrupção altera para mover o tetraminó para baixo
    MOV  R4, 0
    MOV  [R1], R4       ; não permite mais a queda desta peça

    MOV  R1, BOTTOM
    MOV  R4, 1
    MOV  [R1], R4       ; sinaliza que já chegou ao fundo

proxima_linha:
    MOVB [R2], R3         ; guarda o novo valor de CURRENT_L (linha)

    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Faz a rotação do tetraminó
; *             Faz isto alterando o endereço da tabela do tetraminó em jogo
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Utiliza variáveis em memória:
; *               CURRENT_T, com o endereço da tabela atual do tetramino
; *             Altera variável global R8 para 0 quando ocorre uma alteração
; *********************************************************************
tetramino_rotate:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R6
    PUSH R9

    MOV  R1, CURRENT_T
    MOV  R2, [R1]           ; R2 com o endereço do tetraminó atual

    MOVB R3, [R2]           ; número de colunas

    ADD  R2, 1
    MOVB R4, [R2]           ; número de linhas

    MUL  R3, R4
    ADD  R3, 2              ; colunas * linhas + 2 = tamanho total da tabela

    SUB  R2, 1              ; volta á primeira posição da tabela
    ADD  R2, R3             ; CURRENT_T é somado com o seu tamanho, neste endereço começa a próxima tabela

    MOV  R4, LAST_T_TABLE   ; endereço máximo que para o qual pode mudar a tabela atual do tetramino
    MOV  R9, [R4]
    CMP  R9, R2             ; verifica se a tabela é uma das que pertence a este tetraminó
    JNZ  save_rotation

    MOV  R6, FIRST_T_TABLE  ; endereço minimo que para o qual pode mudar a tabela atual do tetramino
    MOV  R2, [R6]           ; quando passa do limite, volta á primeira tabela

save_rotation:
    MOV  [R1], R2           ; guarda o novo valor de CURRENT_T

    MOV  R8, 0            ; não permite mais alterações

    POP  R9
    POP  R6
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Compara a posição que o tetraminó tem com a posição que devia ter
; *             Se as posições forem diferentes, altera a posição para a que devia ter
; *             e desenha o tetraminó na nova posição
; * Recebe    - CURRENT_C, nº da coluna que devia ter
; *           - LAST_C, nº da coluna atual
; *           - CURRENT_L, nº da linha que devia ter
; *           - LAST_L, nº da linha atual
; * Devolve   - nada
; *      notas: quando altera a posição do tetraminó, altera LAST_C e LAST_L
; *             Altera R7 e R9 para 0 quando o tetraminó acaba de se movimentar
; *********************************************************************
tetramino_update:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6
    PUSH  R8
    PUSH  R10
    PUSH  R11

teste_coluna:
    MOV  R2, CURRENT_C
    MOVB R0, [R2]           ; R0 com valor das colunas pretendido

    MOV  R2, LAST_C
    MOVB R1, [R2]           ; R1 com valor das colunas atual

    CMP  R0, R1             ; verifica se não se pretende uma alteração das colunas
    JZ   teste_linha

    CALL altera_coluna
    JMP  keep_tetramino

teste_linha:
    MOV  R2, CURRENT_L
    MOVB R0, [R2]           ; R0 com valor das linhas pretendido

    MOV  R2, LAST_L
    MOVB R1, [R2]           ; R1 com valor das linhas atual

    CMP  R0, R1             ; verifica se não se pretende uma alteração da linha
    JZ   teste_rotacao

    CALL altera_linha
    JMP  keep_tetramino

teste_rotacao:
    MOV  R2, CURRENT_T
    MOV  R0, [R2]           ; R0 com valor das colunas pretendido

    MOV  R2, LAST_T
    MOV  R1, [R2]           ; R1 com valor das colunas atual

    CMP  R0, R1             ; verifica se não se pretende uma alteração das colunas
    JZ   keep_tetramino

    CALL faz_rotacao

keep_tetramino:
    POP  R11
    POP  R10
    POP  R8
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Roda o tetraminó e verifica se a mudança é válida
; * Recebe    - nada
; * Devolve   - R0, flag de erro
; *      notas: quando a mudança não é válida, R0 é diferente de 0
; *********************************************************************
faz_rotacao:
    PUSH R2
    PUSH R8

    CALL change_location

    CMP  R0, 0          ; verifica se houve um erro na mudança
    JNZ  fim_rotacao

    MOV  R2, LAST_T
    MOV  [R2], R8       ; atualiza o endereço da tabela do tetraminó para o seu último valor válido

fim_rotacao:
    POP  R8
    POP  R2
    RET 


; *********************************************************************
; * Descrição - Baixa o tetraminó uma linha e verifica se há obstruçoẽs no caminho
; *             Se há uma obstrução verifica se é o monstro
; * Recebe    - nada
; * Devolve   - R0, flag de erro
; *      notas: quando a mudança não é válida, R0 é o número de pixels no caminho
; *********************************************************************
altera_linha:
    PUSH R2
    PUSH R5

    CALL change_location

    CMP  R0, 0          ; verifica se há uma obstrução
    JZ   confirma_linha

    MOV  R1, EXISTE_M       ; endereço com a variável que diz se o monstro está vivo ou não
    MOVB R2, [R1]
    CMP  R2, 1              ; verifica se o monstro está vivo
    JNZ  colisao_pecas

    CALL verifica_monstro      ; verifica se colidiu com o monstro
    CMP  R0, 1
    JNZ  colisao_pecas

    CALL mata_monstro          ; apaga o monstro
    CALL reset_monstro         ; poe o monstro na sua posição inicial

colisao_pecas:
    MOV  R9, 0          ; já não há um tetraminó ativo no ecrã
    MOV  R7, 0          ; desativa modo de queda
    
    JMP  fim_alt_linha

confirma_linha:
    MOV  R2, LAST_L
    MOVB [R2], R3       ; atualiza a linha para o seu novo valor

fim_alt_linha:
    POP  R5
    POP  R2
    RET


; *********************************************************************
; * Descrição - Verifica se o tetraminó atual está em cima do monstro
; * Recebe    - nada
; * Devolve   - R0, flag que está a 1 quando o tetraminó está em cima do monstro e é 0 no caso contrário
; *      notas: Esta verificação consiste em verificar se as coordenadas do tetraminó 
; *               e as coordenadas do monstro estão próximas o suficiente uma da outra
; *             O processo consiste em ver se qualquer uma das colunas do tetraminó
; *               tem o mesmo número que qualquer uma das colunas do monstro,
; *               mas antes disso é verificado o nº da linha
; *             Todos os valores das linhas e colunas são inicialmente do canto superior esquerdo
; *********************************************************************
verifica_monstro:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R6
    PUSH R7
    PUSH R10
    PUSH R11

    MOV  R0, 0          ; valor que a rotina devolve é inicializado a 0

    MOV  R6, 0
    MOV  R7, 0          ; R6 e R7 são contadores e são iniciados a 0

    MOV  R11, CURRENT_L
    MOVB R1, [R11]          ; R1 com linha atual do tetraminó

    MOV  R11, CURRENT_T     ; endereço com o endereço da tabela utilizada para desenhar o tetraminó
    MOV  R10, [R11]
    ADD  R10, 1             ; o 2º elemento da tabela contém a altura do tetraminó
    MOVB R2, [R10]          ; R2 com altura do tetraminó atual

    MOV  R11, LINHA_M
    MOVB R3, [R11]          ; R3 com linha atual do monstro

    SUB  R3, R1             ; diferença das linhas do monstro e do tetraminó
    CMP  R3, R2             ; verifica se a diferença é igual á altura do tettraminó
    JZ   valores_das_colunas

    ADD  R3, 1          ; no caso de a peça encaixar no monstro, a altura é 1 pixel menor
    CMP  R3, R2         ; compara agora a diferença á altura menos um pixel
    JNZ  nao_e_monstro

valores_das_colunas:
    MOV  R11, CURRENT_C
    MOVB R1, [R11]          ; R1 com coluna atual do tetraminó

    MOV  R11, CURRENT_T
    MOV  R10, [R11]
    MOVB R2, [R10]          ; R2 com comprimento do tetraminó atual

    MOV  R11, COLUNA_M
    MOVB R3, [R11]          ; R3 com coluna mais á esquerda do monstro

    MOV  R11, TABELA_M      ; ; endereço com o endereço da tabela utilizada para desenhar o monstro
    MOV  R10, [R11]
    MOVB R4, [R10]          ; R4 com comprimento do monstro

verifica_colunas:
    CMP  R1, R3             ; compara os valores das colunas do tetraminó e do monstro
    JZ   colunas_iguais

    ADD  R6, 1              ; aumenta o contador
    CMP  R6, R2             ; verifica se o contador é igual ao comprimento
    JGE  proxima_col_monstro

    MOV  R11, CURRENT_C
    MOVB R1, [R11]          ; coluna mais á esquerda do tetraminó
    ADD  R1, R6             ; coluna mais valor do contador (o valor máximo é a coluna mais o comprimento do tetraminó)
                            ; verificam-se assim todas as colunas ocupadas pelo tetraminó
    JMP  verifica_colunas

proxima_col_monstro:
    MOV  R11, CURRENT_C
    MOVB R1, [R11]          ; coluna mais á esquerda do tetraminó
    MOV  R6, 0              ; contador para as colunas do tetraminó reiniciado

    ADD  R7, 1              ; passa á próxima coluna do monstro
    CMP  R7, R4             ; verifica se o contador é igual ao comprimento do monstro
    JGE  nao_e_monstro

    MOV  R11, COLUNA_M
    MOVB R3, [R11]          ; coluna mais á esquerda do monstro
    ADD  R3, R7             ; coluna mais valor do contador (o valor máximo é a coluna mais o comprimento do monstro)
                            ; verificam-se assim todas as colunas ocupadas pelo monstro
    JMP  verifica_colunas

colunas_iguais:
    MOV  R0, 1              ; se as colunas forem iguais retorna R0 a 1

nao_e_monstro:
    POP  R11
    POP  R10
    POP  R7
    POP  R6
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Apaga o monstro, apaga o tetraminó e aumenta a pontuação
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               SCORE, pontuação atual
; *               H_SCORE, pontuação máxima atingida
; *********************************************************************
mata_monstro:
    PUSH R1
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    MOV  R5, 0
    CALL desenha_monstro        ; apaga o monstro

    MOV  R1, LAST_L
    MOVB R6, [R1]               ; R6 com última linha válida do tetraminó

    MOV  R1, LAST_C
    MOVB R7, [R1]               ; R7 com última coluna válida do tetraminó

    MOV  R1, LAST_T
    MOV  R8, [R1]               ; R6 com último desenho válido do tetraminó
    CALL draw_tetramino

    CALL restore_separador      ; repara o buraco no separador

    MOV  R5, 0
    CALL draw_hud       ; apaga os indicadores com a pontuação anterior

    MOV  R1, KILL_MONSTER
    CALL increase_score     ; aumenta a pontuação com o valor de KILL_MONSTER

    MOV  R1, SCORE
    MOVB R6, [R1]           ; R6 com pontuação atual

    MOV  R1, H_SCORE
    MOVB R7, [R1]           ; R7 com melhor pontuação atingida

    CMP  R6, R7
    JLT  no_update_h_score

    MOVB [R1], R6           ; se a pontuação atual é maior que a melhor atingida, atualiza a melhor atingida

no_update_h_score:
    CALL update_hex_display       ; atualiza a pontuação dos displays

    MOV  R5, 1
    CALL draw_hud           ; rescreve os indicadores com a nova pontuação

    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R1
    RET


; *********************************************************************
; * Descrição - Redesenha os pixels do separador que o monstro apaga
; * Recebe    - nada
; * Devolve   - nada
; *********************************************************************
restore_separador:
    PUSH R1
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    
    MOV  R5, 1

    MOV  R1, LINHA_M
    MOVB R6, [R1]           ; linha em que o canto superior esquerdo do monstro está

    MOV  R7, LIM_DIR        ; coluna do separador

    MOV  R8, separador_repair      ; tabela com desenho utilizado para pintar em cima do buraco
    CALL draw_tetramino

    POP  R8
    POP  R7
    POP  R6
    POP  R8
    POP  R1
    RET


; *********************************************************************
; * Descrição - Move o tetraminó uma coluna para um dos lados e verifica se a mudança é válida
; * Recebe    - nada
; * Devolve   - R0, flag de erro
; *      notas: quando a mudança não é válida, R0 é diferente de 0
; *********************************************************************
altera_coluna:
    PUSH R2

    CALL change_location

    CMP  R0, 0          ; verifica se houve um erro na mudança
    JNZ  fim_alt_coluna

    MOV  R2, LAST_C
    MOVB [R2], R4       ; atualiza a coluna para o seu novo valor

fim_alt_coluna:
    POP  R2
    RET


; *********************************************************************
; * Descrição - Apaga o último tetraminó e desenha-o na sua nova posição
; *             Se a nova posição for inválida, volta para a posição anterior
; * Recebe    - nada
; * Devolve   - R3, nova linha em que o tetraminó fica desenhado
; *           - R4, nova coluna em que o tetraminó fica desenhado
; *           - R8, novo endereço da tabela utilizada para desenhar o tetraminó
; *           - R0, flag que diz se existe um problema na posição do novo tetraminó
; *      notas: Se não pode desenhar o tetraminó na nova posição, R0 fica a 1, caso contrário fica a 0
; *             Pode alterar variáveis em memória:
; *               CURRENT_L, linha do tetraminó
; *               CURRENT_C, coluna do tetraminó
; *               CURRENT_T, endereço da tabela utilizada para desenhar o tetraminó
; *********************************************************************
change_location:
    PUSH R2
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R10

    MOV  R5, 0             ; R5 a 0 para a rotina apagar o tetramino

    MOV  R2, LAST_L
    MOVB R3, [R2]          ; R3 com a linha do último tetramino

    MOV  R2, LAST_C
    MOVB R4, [R2]          ; R4 com a coluna do último tetramino

    MOV  R2, LAST_T
    MOV  R8, [R2]          ; R8 com o endereço da tabela do último tetraminó

    MOV  R6, R3
    MOV  R7, R4         ; move os valores para os registos que a rotina recebe

    CALL draw_tetramino    ; apaga o último tetraminó

    MOV  R10, CURRENT_L
    MOVB R3, [R10]          ; altera a linha para a pretendida

    MOV  R10, CURRENT_C
    MOVB R4, [R10]          ; altera a coluna para a pretendida

    MOV  R10, CURRENT_T
    MOV  R8, [R10]          ; altera o tetramino para o pretendido

    MOV  R1, CURRENT_T       ; R1 é utilizado na rotina seguinte como endereço do tetraminó
    CALL check_for_pieces
    CMP  R0, 0              ; verifica se há pixels nessa área
    JNZ  nao_faz_alteracao

faz_alteracao:
    MOV  R5, 1             ; R5 a 1 para a rotina escrever o tetramino
    MOV  R6, R3
    MOV  R7, R4         ; move os valores para os registos que a rotina recebe

    CALL draw_tetramino    ; desenha o novo tetraminó
    JMP  location_set

nao_faz_alteracao:
    CALL revert_tetramino

    MOV  R5, 1
    CALL draw_tetramino    ; desenha o mesmo tetraminó, sem alterações

location_set:
    POP  R10
    POP  R7
    POP  R6
    POP  R5
    POP  R2
    RET


; *********************************************************************
; * Descrição - Dada uma linha e coluna, diz se algum dos pixels onde se vai desenhar o tetraminó está não vazio
; * Recebe    - R3, linha do canto superior esquerdo do tetramino
; *           - R4, coluna do canto superior esquerdo do tetramino
; *           - R1, endereço de memória onde se guarda endereço da tabela do tetraminó
; * Devolve   - R0, número de pixels a 1, na área escolhida (pixels sobrepostos)
; *********************************************************************
check_for_pieces: 
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    MOV  R7, [R1]         ; R7 com endereço da tabela do tetraminó

    MOVB R5, [R7]         ; R5 com comprimento do tetraminó

    ADD  R7, 1            ; passa ao próximo elemento da tabela
    MOVB R8, [R7]         ; R8 com altura do tetraminó

    MOV  R9, 0          ; contador de pixels desenhados
    MOV  R10, 0         ; contador de nº de colunas testadas
    MOV  R11, 0         ; contador de nº de linhas testadas

next_pixel_check:
    ADD  R7, 1          ; passa ao próximo elemento da tabela
    MOVB R6, [R7]       ; R6 com o elemento que é 0 ou 1, para escrever ou não um pixel

    CMP  R6, 1          ; verifica se tem de escrever um pixel nesta posição
    JNZ  dont_check     ; se não escreve neste pixel, vai passar ao próximo

    MOV  R1, R3         ; linha a verificar
    MOV  R2, R4         ; coluna a verificar
    CALL give_pixel_value

    CMP  R0, 0          ; verifica se há alguma coisa escrita no pixel escolhido
    JNZ  pixel_sum

dont_check:
    ADD  R4, 1           ; próxima coluna
    ADD  R10, 1          ; contador para colunas aumenta

    CMP  R10, R5         ; verifica se contador chegou ao limite (comprimento)
    JNZ  next_pixel_check

    SUB  R4, R5         ; quando chega ao limite, volta á coluna mais á esquerda
    MOV  R10, 0         ; reinicia contador para colunas
    ADD  R3, 1          ; passa á próxima linha
    ADD  R11, 1         ; contador para linhas aumenta

    CMP  R11, R8       ; verifica se chegou á última linha
    JZ   end_check

    JMP  next_pixel_check

pixel_sum:
    ADD  R9, 1
    JMP  dont_check

end_check:
    MOV  R0, R9

    POP  R11
    POP  R10
    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Diz se o pixel escolhido está a 0 ou a 1
; * Recebe    - R1, linha do pixel
; *           - R2, coluna do pixel
; * Devolve   - R0, 0 se o pixel estiver pixel vazio ou diferente de 0 se estiver escrito
; *********************************************************************
give_pixel_value:
    PUSH  R1
    PUSH  R2
    PUSH  R4
    PUSH  R5
    PUSH  R8

    MOV  R5, SCREEN     ; endereço do primeiro byte do ecrã

    MOV  R0, R2         ; faz uma copia do r2 (coluna)

    MOV  R8, 4
    MUL  R1, R8         ; multiplica linha por 4

    MOV  R8, 8
    DIV  R2, R8         ; divisao inteira de coluna por 8

    ADD  R1, R2     
    ADD  R5, R1         ; byte do ecra a escrever

    MOV  R4, mascaras
    MOD  R0, R8         ; resto da divisao da coluna por 8
    ADD  R4, R0         ; vai-se encontrar o indice da mascara necessaria
    MOVB R0, [R4]       ; valor da mascara

    MOVB R1, [R5]       ; move o byte atual do ecra para R1
    AND  R0, R1         ; R0 tem o valor do pixel

    POP  R8
    POP  R5
    POP  R4
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Verifica se há uma linha do ecrã preenchida
; *           - Se estiver preenchida, apaga-a e move o resto dos tetraminós para baixo
; * Recebe    - nada
; * Devolve   - R10, 1 se apagar a linha e 0 se não apagar
; *      notas: Utiliza variáveis em memória:
; *               SCORE, pontuação atual
; *               H_SCORE, pontuação máxima atingida
; *             A verificação faz-se com um tetraminó 1x18, horizontal,
; *             contando o número de pixels que se sobrepoem a esse tetraminó
; *********************************************************************
check_complete_line:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOV  R10, 0             ; valor a retornar inicia com valor 0

    MOV  R3, LIM_SCREEN        ; nº do maior pixel fora do ecrã
    SUB  R3, 1                 ; nº da última linha

check_next_line:
    MOV  R1, LAST_LINE         ; endereço de memória com o endereço da tabela 1x18
    MOV  R4, 0                 ; nº da coluna a partir do qual verifica quantos pixels a 1 há
    CALL check_for_pieces      ; a rotina vai devolver R0 com nº de pixels preenchidos

    MOV  R1, LIM_DIR        ; limite esquerdo da área de jogo
    MOV  R2, LIM_ESQ        ; limite direito da área de jogo
    SUB  R1, R2             ; largura da área de jogo, em pixels
    ADD  R1, 1              ; mais o pixel do separador
    CMP  R0, R1             ; compara a largura ao número de pixels preenchidos
    JZ   delete_current_line

    SUB  R3, 1              ; passa á próxima linha (para cima)
    CMP  R3, 0              ; vê se já chegou á última linha
    JNZ  check_next_line

    JMP  dont_delete_line

delete_current_line:
    MOV  R5, 0
    CALL draw_hud       ; apaga os indicadores com a pontuação anterior

    CALL desenha_monstro    ; apaga o monstro

    CALL delete_line

    MOV  R1, COMPLETE_LINE
    CALL increase_score     ; aumenta a pontuação com o valor de COMPLETE_LINE

    CALL update_hex_display       ; atualiza a pontuação dos displays

    MOV  R6, TARGET         ; pontuação a atingir para ganhar o jogo

    MOV  R1, SCORE
    MOVB R4, [R1]           ; R4 com pontuação atual

    MOV  R1, H_SCORE
    MOVB R5, [R1]           ; R5 com melhor pontuação atingida

    CMP  R4, R5
    JLT  dont_raise_h_score

    MOVB [R1], R4           ; se a pontuação atual é maior que a melhor atingida, atualiza a melhor atingida

dont_raise_h_score:
    MOV  R5, 1
    CALL draw_hud       ; rescreve os indicadores com a nova pontuação

    MOV  R0, EXISTE_M
    MOVB R1, [R0]
    CMP  R1, 1          ; verifica se um monstro existe
    JNZ  dont_redraw_monster

    CALL desenha_monstro    ; redesenha o monstro se ele existir

dont_redraw_monster:
    MOV  R10, 1             ; se apagar a linha, a rotina retorna R10 a 1

    CMP  R4, R6             ; verifica se tem pontuação suficiente para ganhar o jogo (R4 é SCORE e R6 é TARGET)
    JLT  dont_delete_line

    CALL reset
    MOV  R8, you_win
    CALL blank_screen       ; se ganhar o jogo, faz reset e mostra uma mensagem de vitória

dont_delete_line:
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Move todos os pixels do ecrã uma linha para baixo
; * Recebe    - R3, linha a partir do qual vai apagar
; * Devolve   - nada
; *      notas: Este processo consiste em copiar o conteudo de cada byte
; *             do ecrã para o byte diretamente em baixo dele
; *********************************************************************
delete_line:
    PUSH R0
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOV  R4, SCREEN     ; primeiro byte do ecrã

    MOV  R6, BY_LINHA      ; número de bytes por linha
    MUL  R3, R6     ; vezes o número de linhas, mais uma linha, pois a primeira linha tem indice 0
    SUB  R3, 1      ; também porque se começa a contar do 0, subtrai-se 1 para se ter o valor correto
    ADD  R3, R6     ; fica-se com o byte a partir de onde é preciso apagar

    MOV  R5, SCREEN
    ADD  R5, R3         ; endereço do último byte que é preciso apagar

    MOV  R3, R5
    SUB  R3, BY_LINHA   ; byte diretamente em cima do byte em R5

delete_next_byte:
    MOVB R0, [R3]       ; copia o valor do byte para R0
    MOVB [R5], R0       ; copia o valor do byte para o byte em baixo dele

    SUB  R5, 1
    SUB  R3, 1          ; passa aos próximos 2 bytes, um em cima do outro

    CMP  R3, R4             ; quando chegar ao byte mais em cima e á esquerda, pára
    JNZ  delete_next_byte

    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R0
    RET


; *********************************************************************
; * Descrição - Altera as coordenadas e o tetraminó para a sua última configuração válida
; * Recebe    - nada
; * Devolve   - R6, linha em que o tetraminó estava anteriormente
; *           - R7, coluna em que o tetraminó estava anteriormente
; *           - R8, tetraminó anterior
; *      notas: Altera variáveis em memória:
; *               CURRENT_L, nº da linha do tetraminó
; *               CURRENT_C, nº da coluna do tetraminó
; *               CURRENT_T, endereço da tabela utilizada para desenhar o tetraminó
; *********************************************************************
revert_tetramino:
    PUSH R10

    MOV  R10, LAST_L
    MOVB R6, [R10]          ; altera a linha para a pretendida

    MOV  R10, LAST_C
    MOVB R7, [R10]          ; altera a coluna para a pretendida

    MOV  R10, LAST_T
    MOV  R8, [R10]          ; altera o tetramino para o pretendido

    MOV  R10, CURRENT_L
    MOVB [R10], R6          ; altera a linha, em memória

    MOV  R10, CURRENT_C
    MOVB [R10], R7          ; altera a coluna, em memória

    MOV  R10, CURRENT_T
    MOV  [R10], R8          ; altera o tetramino, em memória

    POP R10
    RET


; *********************************************************************
; * Descrição - Lê o valor da tecla premida, se houver uma, e faz START, PAUSE/CONTINUE, RESET
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Depende de R11, que está ativo quando há uma tecla premida
; *             Altera R6 para 0 depois de efetuar uma das operaçóes possiveis
; *********************************************************************
control:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R5
    PUSH  R8
    PUSH  R10
    PUSH  R11

    CMP  R11, 1         ; verifica se há alguma tecla premida
    JNZ  end_control

    CMP  R6, 1          ; verifica se tem permissão (só é dada quando se pára de carregar na mesma tecla)
    JNZ  end_control

    MOV  R1, TECLA      ; R1 com endereço da tecla
    MOVB R0, [R1]       ; R0 com o valor da tecla

test_start:
    CMP  R0, START         ; verifica se é a tecla de start
    JNZ  test_pause        ; se nao for, passa ao próximo teste

    CALL start_game
    JMP  end_control

test_pause:
    MOV  R1, GAME_STATE
    MOVB R3, [R1]
    CMP  R3, 1              ; verifica se o jogo está em progresso
    JNZ  test_reset         ; salta o teste da tecla de pausa se o jogo ainda não fez start

    CMP  R0, PAUSE         ; verifica se é a tecla de pausa
    JNZ  test_reset

    MOV  R1, PAUSE_MODE
    MOVB R8, [R1]           ; R8 com o estado de pausa do jogo

    MOV  R10, 0
    CMP  R8, R10            ; compara PAUSE_MODE a 0
    JZ   continue_game      ; se estiver a 0, passa a estar a 1
                            ; se estiver a 1, passa para 0    
    CALL pause
    JMP  end_control

continue_game:
    
    CALL continue
    JMP  end_control

test_reset:
    CMP  R0, RESET          ; verifica se é a tecla de reset
    JNZ  end_control

    CALL reset

    MOV  R5, 1
    CALL draw_hud       ; atualiza os indicadores de pontuação

end_control:
    POP  R11
    POP  R10
    POP  R8
    POP  R5
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Altera o estado do jogo para 'em progresso'
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               GAME_STATE, 0 para jogo parado, 1 para jogo em progresso
; *               FIRST_MOVE, 1 quando é o primeiro  movimento do jogo, 0 para o oposto 
; *               SCORE, com a pontuação atual do jogador
; *             Altera R6 para 0
; *             Fazer start a meio do jogo não tem efeito nenhum
; *********************************************************************
start_game:
    PUSH R1
    PUSH R3
    PUSH R5

    MOV  R1, GAME_STATE
    MOV  R3, 1
    MOVB [R1], R3       ; GAME_STATE a 1 - jogo em progresso

    MOV  R6, 0          ; remove permissão para interrupções

    MOV  R1, FIRST_MOVE
    MOVB R3, [R1]
    CMP  R3, 1             ; por causa de FIRST_MOVE, o primeiro start também faz continue
    JNZ  end_start_game

    CALL clear_screen

    MOV  R5, SCORE
    MOV  R1, 0
    MOV  [R5], R1        ; faz reset da pontuação

    MOV  R5, 1
    CALL draw_hud            ; desenha os indicadores de pontuação
    CALL update_hex_display  ; atualiza a pontuação
    CALL continue

end_start_game:
    POP  R5
    POP  R3
    POP  R1
    RET


; *********************************************************************
; * Descrição - Faz pausa do jogo
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera R6 para 0
; *             Altera variáveis em memória:
; *               PAUSE_MODE, 0 para jogo em pausa, 1 para jogo em progresso
; *********************************************************************
pause:
    PUSH R1
    PUSH R3

    CALL pause_sign     ; desenha o botão de pausa

    MOV  R3, 0
    MOVB [R1], R3       ; pausa ativada

    MOV  R6, 0          ; remove permissão para interrupções

    POP  R3
    POP  R1
    RET


; *********************************************************************
; * Descrição - Sai do modo de pausa
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera R6 para 0
; *             Altera variáveis em memória:
; *               PAUSE_MODE, 0 para jogo em pausa, 1 para jogo em progresso
; *               FIRST_MOVE, variável é 1 quando é a primeira jogada, fica a 0 a partir dai
; *             Depois do primeiro 'continue', START já não recomeça o jogo
; *********************************************************************
continue:
    PUSH R1
    PUSH R3

    CALL pause_sign     ; apaga o botão de pausa

    MOV  R3, 1
    MOV  R1, PAUSE_MODE
    MOVB  [R1], R3          ; pausa desativada

    MOV  R6, 0          ; remove permissão para interrupções

    MOV  R1, FIRST_MOVE
    MOV  R3, 0
    MOVB [R1], R3       ; FIRST_MOVE é dasativado

    POP  R3
    POP  R1
    RET


; *********************************************************************
; * Descrição - Pára o jogo e limpa o ecrã
; * Recebe    - nada
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               GAME_STATE, 0 para jogo parado, 1 para jogo em progresso
; *               PAUSE_MODE, 0 para jogo em pausa, 1 para jogo em progresso
; *               FIRST_MOVE, variável é 1 quando é a primeira jogada, fica a 0 a partir dai
; *             Altera R6, R7, R9 para 0
; *********************************************************************
reset:
    PUSH R1
    PUSH R3
    PUSH R5

    MOV  R1, GAME_STATE
    MOV  R3, 0
    MOVB [R1], R3             ; GAME_STATE a 0 - faz stop

    MOV  R1, PAUSE_MODE
    MOV  R3, 0
    MOVB [R1], R3             ; PAUSE_MODE a 0 - faz pausa

    MOV  R1, FIRST_MOVE
    MOV  R3, 1
    MOVB [R1], R3             ; FIRST_MOVE a 1 - agora o primeiro start também faz continue

    CALL  clear_all          ; limpa o ecrã
    CALL  reset_monstro      ; põe o monstro na sua posição inicial

    MOV  R9, 0          ; já não há um tetraminó controlável no ecrã
    MOV  R7, 0          ; queda livre desligada
    MOV  R6, 0          ; remove permissão para interrupções

    POP  R5
    POP  R3
    POP  R1
    RET


; *********************************************************************
; * Descrição - Desenha ou apaga o botão de pausa, dependendo do estado de PAUSE_MODE
; * Recebe    - nada
; * Devolve   - nada
; *********************************************************************
pause_sign:
    PUSH R0
    PUSH R1
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9

    MOV  R1, PAUSE_MODE
    MOVB R0, [R1]      ; R0 com valor de PAUSE_MODE

    CMP  R0, 0         ; verifica se o jogo está pausado
    JNZ  draw_pause

delete_pause:
    MOV  R5, 0              ; argumento da rotina para apagar

    MOV  R9, pause_location
    MOVB R6, [R9]           ; linha do botão

    ADD  R9, 1
    MOVB R7, [R9]           ; coluna do botão

    MOV  R8, paused
    CALL draw_tetramino        ; apaga o botão de pausa

    JMP  pause_sign_end

draw_pause:
    MOV  R5, 1              ; argumento da rotina para desenhar

    MOV  R9, pause_location
    MOVB R6, [R9]           ; linha do botão

    ADD  R9, 1
    MOVB R7, [R9]           ; coluna do botão

    MOV  R8, paused
    CALL draw_tetramino        ; desenha o botão de pausa

pause_sign_end:
    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Aumenta a pontuação do jogador
; * Recebe    - R1, valor a acrescentar á pontuação
; * Devolve   - nada
; *      notas: Altera variáveis em memória:
; *               SCORE, com a pontuação atual do jogador
; *********************************************************************
increase_score:
    PUSH R1
    PUSH R5
    PUSH R6

    MOV  R5, SCORE
    MOVB R6, [R5]       ; R6 com o valor da pontuação

    ADD  R6, R1         ; adiciona R1 á pontuação

    MOVB [R5], R6       ; guarda o novo valor

    POP  R6
    POP  R5
    POP  R1
    RET


; *********************************************************************
; * Descrição - Escreve ou apaga os contadores de pontuação e a pontuação
; * Recebe    - R5, 1 para escrever e 0 para apagar
; * Devolve   - nada
; *********************************************************************
draw_hud:
    PUSH R3
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9

    MOV  R9, hud_location       ; tabela com localizações do texto

draw_high_text:
    MOVB R6, [R9]               ; R6 com linha onde se vai desenhar

    ADD  R9, 1
    MOVB R7, [R9]               ; R6 com coluna onde se vai desenhar

    MOV  R8, high               ; R8 com endereço da tabela do que se vai desenhar
    CALL draw_tetramino

draw_score_text:
    ADD  R9, 1
    MOVB R6, [R9]                  ; o mesmo para o resto das coisas a escrever

    ADD  R9, 1
    MOVB R7, [R9]

    MOV  R8, score
    CALL draw_tetramino

draw_high_score:
    MOV  R11, H_SCORE

    ADD  R9, 1
    MOVB R6, [R9]

    ADD  R9, 1
    MOVB R7, [R9]

    ADD  R9, 1
    MOVB R3, [R9]                 ; os números têm duas colunas, um para cada digito
    CALL draw_numbers

draw_score_text2:
    ADD  R9, 1
    MOVB R6, [R9]

    ADD  R9, 1
    MOVB R7, [R9]

    MOV  R8, score
    CALL draw_tetramino

draw_score:
    MOV  R11, SCORE

    ADD  R9, 1
    MOVB R6, [R9]

    ADD  R9, 1
    MOVB R7, [R9]

    ADD  R9, 1
    MOVB R3, [R9]
    CALL draw_numbers

    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R3
    RET


; *********************************************************************
; * Descrição - Desenha os dois digitos da pontuação no ecrã
; * Recebe    - R11, endereço onde se guarda o valor a escrever
; *           - R6, linha onde se vão escrever os digitos
; *           - R7, coluna onde se vai escrever o primeiro digito
; *           - R3, coluna onde se vai escrever o segundo digito
; * Devolve   - nada
; *********************************************************************
draw_numbers:
    PUSH R0
    PUSH R1
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R11

    CALL give_score_digits

    MOV  R8, R0              ; R0 é retornado pela rotina give_score_digits
    CALL draw_tetramino      ; desenha o primeiro digito

    MOV  R7, R3
    MOV  R8, R1              ; R1 é retornado pela rotina give_score_digits
    CALL draw_tetramino

    POP  R11
    POP  R8
    POP  R7
    POP  R6
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Dado um endereço de memória com um número decimal de dois digitos, 
; *             devolve os endereços das tabelas dos dois números que constituem esse número
; * Recebe    - R11, endereço de memória onde está o número a representar
; * Devolve   - R0, endereço da tabela do digito das dezenas
; *           - R1, endereço da tabela do digito das unidades
; *********************************************************************
give_score_digits:
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    MOVB R10, [R11]        ; R10 valor da pontuação atual

    MOV  R9, R10           ; cópia do valor

    MOV  R7, DEZ

    DIV  R10, R7           ; digito das dezenas
    MOD  R9, R7            ; digito das unidades

    MOV  R8, digitos       ; tabela com os endereços das tabelas dos digitos

    MOV  R7, 2          ; vai-se multiplicar por 2 pois está-se a aceder a WORD's

    MUL  R10, R7
    ADD  R10, R8
    MOV  R0, [R10]          ; R0 com endereço da tabela do digito das dezenas

    MUL  R9, R7
    ADD  R9, R8
    MOV  R1, [R9]          ; R0 com endereço da tabela do digito das unidades

    POP  R11
    POP  R10
    POP  R9
    POP  R8
    POP  R7
    RET


; *********************************************************************
; * Descrição - Limpa totalmente o ecrã e mostra uma mensagem
; * Recebe    - R8, endereço da tabela da mensagem a mostrar
; * Devolve   - nada
; *********************************************************************
blank_screen:
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9

    CALL clear_all      ; limpa o ecrã
    
    MOV  R5, 1          ; argumento da rotina para desenhar

    MOV  R9, text_message_location
    MOVB R6, [R9]           ; linha onde se desenha

    ADD  R9, 1
    MOVB R7, [R9]           ; coluna onde se desenha
    CALL draw_tetramino

    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    RET


; *********************************************************************
; * Descrição - Se o monstro estiver em condiçoẽs de ser criado, desenha o monstro
; *             Depois de o monstro estar no ecrã, verifica se a variável que permite o seu movimento está ativada
; *             Se esta variável estiver ativada, move o monstro uma coluna para a esquerda
; * Recebe    - nada
; * Devolve   - nada
; *      notas: As condições para o monstro ser criado incluem:
; *               -não existir já um monstro
; *               -o jogo estar em progresso
; *               -a variável aleatória ter um determinado valor
; *             Altera variáveis em memória:
; *               EXISTE_M, que está a 1 quando existe um monstro e a 0 caso contrário
; *               MOVE_M, que permite o movimento do monstro quando está a 1
; *********************************************************************
monstro:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5
    PUSH R8
    PUSH R10

    MOV  R0, EXISTE_M
    MOVB R1, [R0]
    CMP  R1, 0          ; verifica se um monstro já existe
    JNZ  dont_draw_new_monster

    MOV  R0, GAME_STATE
    MOVB R2, [R0]
    CMP  R2, 1          ; verifica se o jogo está em progresso
    JNZ  fim_monstro

    CMP  R9, 0          ; verifica se está no fim de uma jogada
    JNZ  fim_monstro

    MOV  R0, PROB_M
    MOD  R10, R0        ; R10 é a variável global aleatória e é feita a divisão inteira por PROB_M
    CMP  R10, 0         ; se a variável aleatória for múltiplo de PROB_M, cria o monstro
    JNZ  fim_monstro

    MOV  R5, 1
    CALL desenha_monstro        ; desenha um novo monstro

    MOV  R0, EXISTE_M
    MOV  R1, 1
    MOVB [R0], R1       ; ativa a flag de existência do monstro

    JMP  fim_monstro

dont_draw_new_monster:
    MOV  R1, MOVE_M
    MOVB R5, [R1]
    CMP  R5, 1          ; verifica se a flag que a interrupção muda está a 1
    JNZ  fim_monstro

    MOV  R5, 0
    CALL desenha_monstro        ; apaga o monstro anterior

    CALL move_monstro           ; move para a esquerda
    CMP  R0, 1                  ; verifica se chegou á coluna da esquerda
    JZ   monster_end_game

    CALL monstro_obstacle       ; verifica se há algum tetraminó em frente do monstro
    CMP  R0, 0                  ; R0 é o número de pixels desenhados, na posição do monstro, depois de o mover para a esquerda
    JZ   no_obstacle

monster_end_game:
    MOV  R5, 1
    CALL desenha_monstro        ; desenha o monstro na sua posição final

    CALL reset                  ; quando o monstro chega á esquerda, o jogo acaba
    MOV  R8, game_over          ; texto mostrado no fim do jogo
    CALL blank_screen

    MOV  R7, 0              ; desativa modo de queda rápida do tetraminó
    MOV  R9, 0              ; já não há um tetraminó no ecrã

    JMP  fim_monstro

no_obstacle:
    MOV  R5, 1
    CALL desenha_monstro        ; desenha o monstro na sua nova posição

    MOV  R1, MOVE_M
    MOV  R5, 0
    MOVB [R1], R5               ; Altera a flag que a interrupção muda para 0 (não permite mais movimento)

fim_monstro:
    POP  R10
    POP  R8
    POP  R5
    POP  R2
    POP  R1
    POP  R0
    RET


; *********************************************************************
; * Descrição - Muda as coordenadas do monstro para a sua posição inicial, na coluna mais á direita
; * Recebe    - R5, 1 para escrever e 0 para apagar
; * Devolve   - nada
; *      notas: A variável em memória EXISTE_M, 
; *             que sinaliza a existência do monstro quando está a 1, é alterada para 0
; *********************************************************************
reset_monstro:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

    MOV  R1, COLUNA_M           ; endereço com a coluna do monstro
    MOV  R2, LIM_SCREEN         ; nº do pixel limite do ecrã

    MOV  R3, monstro_drawing    ; tabela com informação para desenhar o monstro
    MOVB R4, [R3]               ; R4 com o coprimento do monstro

    SUB  R2, R4                 ; limite do ecrã menos o comprimento do monstro

    MOVB [R1], R2               ; COLUNA_M fica com a coluna mais á direita em que é possival desenhar o monstro

    MOV  R2, EXISTE_M
    MOV  R1, 0
    MOVB [R2], R1       ; desativa a flag de existência do monstro

    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET


; *********************************************************************
; * Descrição - Move o monstro uma coluna para a esquerda e verifica se 
; *             já chegou ao limite esquerdo da área de jogo
; * Recebe    - nada
; * Devolve   - R0, 1 quando o monstro chega á coluna com o valor LIM_ESQ e 0 em caso contrário
; *      notas: Altera variáveis em memória:
; *               COLUNA_M, contém o nº da coluna em que o monstro está atualmente
; *********************************************************************
move_monstro:
    PUSH R3
    PUSH R4

    MOV  R0, 0                  ; variável que a rotina devolve iniciada a 0

    MOV  R3, COLUNA_M           ; endereco da variável que indica a coluna do monstro
    MOVB R4, [R3]               ; R4 com a coluna do monstro
    
    SUB  R4, 1                  ; mover uma coluna para a esquerda
    CMP  R4, LIM_ESQ            ; nº da coluna mais á esquerda da área de jogo
    JNZ  save_monstro

    MOV  R0, 1                  ; se o monstro estiver na coluna mais á esquerda, retorna R0 a 1

save_monstro:
    MOVB [R3], R4               ; guarda o novo valor

    POP  R4
    POP  R3
    RET 


; *********************************************************************
; * Descrição - Desenha ou apaga o monstro
; * Recebe    - R5, 1 para escrever e 0 para apagar
; * Devolve   - nada
; *********************************************************************
desenha_monstro:
    PUSH R4
    PUSH R6
    PUSH R7
    PUSH R8

    MOV  R4, LINHA_M
    MOVB R6, [R4]                   ; R6 com linha em que se vai desenhar
    MOV  R4, COLUNA_M
    MOVB R7, [R4]                   ; R7 com coluna em que se vai desenhar
    MOV  R8, monstro_drawing        ; R8 com a tabela do monstro
    CALL draw_tetramino             ; desenha um novo monstro

    POP  R8
    POP  R7
    POP  R6
    POP  R4
    RET


; *********************************************************************
; * Descrição - Verifica se há algum pixel sobreposto onde se quer desenhar o monstro
; * Recebe    - nada
; * Devolve   - R0, nº de pixels sobrepostos
; *      notas: quando o monstro passa pelo separador,
; *             a rotina subtrai o nº de pixels sobrepostos com o separador
; *********************************************************************
monstro_obstacle:
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R10

    MOV  R10, LINHA_M
    MOVB R3, [R10]          ; R3 com nº da linha do monstro
    MOV  R10, COLUNA_M
    MOVB R4, [R10]          ; R4 com nº da coluna do monstro
    MOV  R1, TABELA_M       ; R1 com variável em memória, com o endereço da tabela do monstro
    CALL check_for_pieces   ; vai retornar R0 com o nº de pixels a 1, na área escolhida

    MOV  R10, LIM_DIR
    CMP  R4, R10            ; verifica se o nº da coluna do monstro é igual ao nº da coluna do separador
    JZ   coluna_separador

    SUB  R10, 1
    CMP  R4, R10            ; verifica se é a primeira coluna á esquerda do separador
    JZ   coluna_separador_esq

    JMP  return_obstacle

coluna_separador:
    SUB  R0, MONSTRO_SEP1   ; quando o monstro passa pelo separador, há 2 pixels que se sobrepõem
    JMP  return_obstacle    ; estes pixels vão ser ignorados 

coluna_separador_esq:
    SUB  R0, MONSTRO_SEP2   ; na primeira coluna á esquerda do separador, há 1 pixel do separador que se sobreõe com o monstro
    JMP  return_obstacle    ; este pixel vai ser ignorado

return_obstacle:
    POP  R10
    POP  R4
    POP  R3
    POP  R1
    RET