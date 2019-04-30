#!/bin/bash
# Arquivo principal para o programa


azul_n='\e[01;44m'

branc_n='\e[01;37m'

verde_n='\e[01;32m'

verm_n='\e[01;31m'

res='\e[m'


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
		echo -e "\n"
		echo -e "Não consegui entender..."
		echo -e "Você pesquisou por Renders Hentai ou Renders Anime? [H/A]\c"
		read dec
		_loop_dec
	fi
}

clear

setterm -cursor off

trap _ctrl_c SIGINT SIGTERM

cat <<MEN

                 DOWNLOAD MG-RENDERS :~
    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

      Para começar faça uma busca no site:
       -> mg-renders.net

      Depois, só copiar a url e colar aqui
    em baixo.

    =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

MEN

echo -e "Antes me diga uma coisa... \nVocê pesquisou por Renders Hentai ou Renders Anime? [H/A]\c"
read dec

_loop_dec

exit 0
