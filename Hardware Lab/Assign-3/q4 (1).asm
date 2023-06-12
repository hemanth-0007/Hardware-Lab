section .data
	newl : db 10

	msg1: db 'enter array elements',10
	siz1 : equ $-msg1

	msgn : db 'enter array size',10
	sizn :  equ $-msgn

	msg2 : db 'enter element to findout',10
	siz2 : equ $-msg2
	
	msg3:db 'found',10
	siz3:equ $-msg3
	
	msg4:db 'Not found',10
	siz4:equ $-msg4

section .bss

	num : resw 1
	temp : resw 1
	count : resw 1
	array : resw  100
	n : resw 1
	i : resw 1
	j : resw 1
	x : resw 1
 	f : resb 1
 	nf : resb 1

section .text
	global _start:
_start:
	mov byte[f],1
	mov byte[nf],0
	mov eax,4
	mov ebx,1
	mov ecx,msgn 
	mov edx,sizn
	int 80h

	call read_num
	mov ax ,word[num]
	mov word[n],ax

	mov eax,4
	mov ebx,1
	mov ecx,msg1 
	mov edx,siz1
	int 80h

	mov eax,0
	mov ebx,array

	call read_array
	mov eax,4
	mov ebx,1
	mov ecx,msg2 
	mov edx,siz2
	int 80h

	call read_num
	mov ax,word[num]
	mov word[x],ax

	mov eax,0
	mov ebx,array
liner_search:
	mov word[i],0
	loop:
		mov ax,word[i]
		cmp word[n],ax
		je not_found
		mov eax,dword[i]
		mov cx,word[ebx+2*eax]
		cmp word[x],cx
		je found
		inc word[i]
		jmp loop


found:
	mov eax,4
	mov ebx,1
	mov ecx,msg3 
	mov edx,siz3
	int 80h
	
	mov eax,1
	mov ebx,0
	int 80h

not_found:
	mov eax,4
	mov ebx,1
	mov ecx,msg4
	mov edx,siz4
	int 80h
	
	mov eax,1
	mov ebx,0
	int 80h

read_num:
	pusha
	mov word[num],0

	read:

		mov eax,3
		mov ebx,0
		mov ecx,temp
		mov edx,1
		int 80h

		cmp byte[temp],10
		je end_read

	mov ax,word[num]
	mov bx,10
	mul bx
	mov bl,byte[temp]
	sub bl,30h
	mov bh,0	
	add ax,bx
	mov word[num],ax
	jmp read
end_read:
	 popa
	 ret

print_num:
	pusha

	mov byte[count],0

	ext:

		cmp word[num],0
		je print
		inc byte[count]
		mov dx,0
		mov ax,word[num]
		mov bx,10
		div bx
		push dx
		mov word[num],ax
		jmp ext

	print:
		cmp byte[count],0
		je end_print
		dec byte[count]
		pop dx
		mov byte[temp], dl
		add byte[temp],30h
		mov eax,4
		mov ebx,1
		mov ecx,temp
		mov edx,1
		int 80h
		jmp print


end_print:
	mov eax,4
	mov ebx,1
	mov ecx,newl
	mov edx,1
	int 80h
	popa
	ret

read_array:
	pusha

	read_loop:
		cmp eax,dword[n]
		je end_read_loop
		call read_num
		mov cx,word[num]
		mov word[ebx+2*eax],cx
		inc eax
		jmp  read_loop
	end_read_loop:
		popa
		ret	

end:
	mov eax,1
	mov  ebx,0
	int 80h
