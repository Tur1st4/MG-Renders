#!/bin/bash
# Arquivo para download de Renders Anime

#========================| VARIAVEIS |========================#

azul_n='\e[01;44m'

branc_n='\e[01;37m'

verde_n='\e[01;32m'

verm_n='\e[01;31m'

res='\e[m'

pasta_exec="Execucoes"

pw=$(pwd)

next_l=300

next_l_v=1

save=$(cat "$pw/Execucoes/save.tur1st4")

centro=$(( $(tput cols) /3 +4 ))

quarto=$(( $(tput cols) /4 +4 ))

dec_sex=$(( $(tput cols) /16 +4 ))

baixar_l=2

#========================| FUNÇÕES |========================#

_manipulando_inicio(){
	cd "$pasta_exec/Principal"

	wget "$PASTE" -O principal.html

	grep 'mtitle' principal.html | sed -f "$pw/Sed/titulo.sed" > urls.txt

	grep "Next" principal.html | sed -f "$pw/Sed/prox.sed" >> "$pw/Execucoes/Loop/nextld$next_l_v.txt"

	cd "$pw/Execucoes/Loop"
}

_manipulando_loop(){
	sla=$(wc -l nextld$next_l_v.txt | awk '{print $1}')
		while [[ "$sla" != 0 ]]
		do
			wget -i nextld$next_l_v.txt -O nextll$next_l.html

	            	let next_l_v=next_l_v+1;

        	    	grep "Next" nextll$next_l.html | sed -f "$pw/Sed/prox.sed" >> "nextld$next_l_v.txt"

			let next_l=next_l-1;

            		sla=$(wc -l nextld$next_l_v.txt | awk '{print $1}')

            		if [[  $sla == 0 ]]
			then
				break
			fi
		done
}

_download_renders(){
	grep 'mtitle' *.html | sed -f "$pw/Sed/titulo.sed" >> "$pw/Execucoes/Principal/urls.txt"

	cd "$pw/Execucoes/Principal"

	grep "'" urls.txt | sed -f "$pw/Sed/pont.sed" >> "$pw/Execucoes/Principal/urlsd.txt"

	pasta_b=$(grep '<center><h1>' principal.html | sed -f "$pw/Sed/pasta_b.sed")

	cd "$pw/Execucoes/Loop"

	wget -i "$pw/Execucoes/Principal/urlsd.txt"

	grep "id='arender'" * | sed -f "$pw/Sed/down.sed" > download.txt

	img_b=$(wc -l download.txt | awk '{print $1}')

	cd "$save"

	if [[ -d '$pasta_b' ]]
	then
		cd "$pasta_b"
		
        	wget -i "$pw/Execucoes/Loop/download.txt"
	else
		mkdir "$pasta_b"
		
        	cd "$pasta_b"
		
        	wget -i "$pw/Execucoes/Loop/download.txt"
	fi
}

_apagar_inuteis(){
	rm "$pw/Execucoes/Principal/"*
	
    	rm "$pw/Execucoes/Loop/"*
	
    	rm "erro.fodeu"
}

declare -x _frases=("Baixando e manipulando os .htmls..."

            "Baixando e manipulando proximos...."

            "Baixando as imagens................"

            "Apagando arquivos desnecessários..."
)

declare -x _comandos=("_manipulando_inicio"
              "_manipulando_loop"
              "_download_renders"
              "_apagar_inuteis"
)

_rodar(){
	{
		while true
		do
			trap "exit" SIGUSR1
		done; } &

        pid=$!
}

_verificacao(){
	for n in {0..3}; do
		echo -e "\n"
		
        	echo -en "$branc_n > $res"; echo -en ${_frases[$n]}
		
        	_rodar

		sleep 2; eval ${_comandos[$n]} >> erro.fodeu 2>erro.fodeu

	if [[ "$?" == "0" ]]
	then
        	echo -en "$verde_n [ok]$res"
		
        	kill -USR1 $pid
		
        	wait $pid
		
        	trap EXIT
	else
        	echo -en "$verm_n [erro]$res"
		
        	setterm -cursor on
		
        	kill -USR1 $pid
		
        	trap EXIT
		
        	exit $?
	fi
	done
}

_finalizar(){
	if [[ $LOOP == @(S|s|Sim|sim|SIM) ]]
	then
		cd "$pw"
		
        	./main.sh
	elif [[ $LOOP == @(N|n|Nao|nao|NAO|Não|não|NÃO) ]]
	then
		clear
		
        	echo -e "\n         O script foi finalizado com sucesso! ^-^\n"
        
        	setterm -cursor on
        
        	exit 0
	else
        	echo -e "Não cosegui entender..."
		
        	setterm -cursor on
		
        	echo -e "$branc_n Deseja fazer outro download? [S/N]$res\c"
		
        	read LOOP
		
        	setterm -cursor off
		
        	_loop_p
	fi
}

#========================| INICIALIZAR |========================#

echo -e "$verm_n\n --> A$res"

setterm -cursor on

echo -e "$branc_n\n  Cole aqui a url: $res\c"

read PASTE

setterm -cursor off

clear

_verificacao

echo -e "$verde_n\n\n >$res Imagens baixadas: $img_b"

echo -e "$verde_n\n >>$res O seu download foi concluido com sucesso!"

setterm -cursor on

echo -e "$branc_n\n Deseja fazer outro download? [S/N]$res\c"

read LOOP

setterm -cursor off

_finalizar

exit 0
