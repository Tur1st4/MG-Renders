#!/bin/bash
# Arquivo principal para o programa

#========================| VARIAVEIS |========================#

azul_n='\e[01;44m'

branc_n='\e[01;37m'

verde_n='\e[01;32m'

verm_n='\e[01;31m'

res='\e[m'

pw=$(pwd)

centro=$(( $(tput cols) /3 ))

quarto=$(( $(tput cols) /4 +4 ))

dec_sex=$(( $(tput cols) /16 +4 ))

export loop=14

#========================| FUNÇÕES |========================#

_ctrl_c(){
	rm Execucoes/Principal/*
	
	rm Execucoes/Loop/*
	
	rm erro.fodeu
	
	clear
	
	echo -e "\n"
	
	echo -e "Você apertou$verm_n Ctrl+C$res.\nEntão sou obrigado a parar ;-;"
	
	echo -e "\n"
	
	setterm -cursor on
	
	exit 127
}

_loop_dec(){
	if [[ $dec == @(H|h|Hentai|hentai|HENTAI) ]]
	then
		./next_h.sh
	elif [[ $dec == @(A|a|Anime|anime|ANIME) ]]
	then
		./next.sh
	else	
		echo -e "Não consegui entender..."
		
		setterm -cursor on
		
		echo -e "Você pesquisou por Renders Hentai ou Renders Anime? [H/A]\c"
		
		read dec
		
		setterm -cursor off
		
		_loop_dec
	fi
}

#========================| INICIALIZAR |========================#

clear

setterm -cursor off

trap _ctrl_c SIGINT SIGTERM

echo -e "\n         DOWNLOAD MG-RENDERS :~"

echo -e "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

echo -e "\n Para começar faça uma busca no site:"

echo -e "\n  -> mg-renders.net"

echo -e "\n Depois, só copiar a url e colar aqui"

echo -e "em baixo."

echo -e "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n"

echo -e "Antes me diga uma coisa..."

setterm -cursor on

echo -e "Você pesquisou por Renders Hentai ou Renders Anime? [H/A]\c"

read dec

setterm -cursor off

_loop_dec

exit 0
