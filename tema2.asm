%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text

word_search:
;luam imaginea si pregatim contorul pentru loop
    mov eax, [img_width]
    mov ebx, [img_height]
    mul ebx
    mov ebx,eax
    mov eax, [img]
    xor ecx, ecx
    xor esi, esi
;loop ul in care incrementam esi pentru a incerca toate cheile    
brut_force:
    inc esi
    xor ecx,ecx
;parcurgem imaginea din vector, pixel cu pixel        
pixel_by_pixel:
    mov edx,[eax + 4*ecx]
    ;xoram si verificam dupa 'r'
    xor edx,esi
    cmp edx, 'r'
    je revient
    inc ecx
    cmp ecx, ebx
    jl pixel_by_pixel 

    cmp esi, 255
    jle brut_force
    
    jmp done
    
revient:
;verificam dupa restul cuvantului
    inc ecx
    push ecx
    mov edx,[eax + 4*ecx]
    xor edx,esi
    cmp edx, 'e'
    jne back
    
    inc ecx
    mov edx,[eax + 4*ecx]
    xor edx,esi
    
    cmp edx, 'v'
    jne back
    
    inc ecx
    mov edx,[eax + 4*ecx]
    xor edx,esi
    
    cmp edx, 'i'
    jne back
    
    inc ecx
    mov edx,[eax + 4*ecx]
    xor edx,esi
    
    cmp edx, 'e'
    jne back
    
    inc ecx
    mov edx,[eax + 4*ecx]
    xor edx,esi
    
    cmp edx, 'n'
    jne back
    
    inc ecx
    mov edx,[eax + 4*ecx]
    xor edx,esi
    
    cmp edx, 't'
    jne back
  
    jmp print_ans
;inapoi la cautare si la vechiul index
back:
    pop ecx
    jmp pixel_by_pixel
    
    leave
    ret


blur_image:
    push ebp
    mov ebp, esp
    
;pregatire imagine si index    
    mov eax, [img]
    xor ecx, ecx
    xor esi, esi
    mov ebx, [img_width]
    sub ebx, 1
;tratam prima linie separat pentru ca ea ramane la fel    
first_line:
    mov edx,[eax + 4*ecx]
    push edx
    inc ecx
    cmp ecx, ebx
    jl first_line
    mov edx,[eax + 4*ecx]
;pusham valorile pentru a reconstrui matricea
    push edx
    inc ecx
    
    xor ebx,ebx
    add ebx,[img_width]
    mov ecx, ebx
    sub ebx,1     
    mov esi, 2
for_loop:
    add ebx, [img_width]    
    inc esi
;primul element de pe linie    
    mov edx,[eax + 4*ecx]
    push edx
    
    inc ecx                
pixel_by_pixel3:
;bluram pixelul adunand 
    mov edx,[eax + 4*ecx]
    xor edi, edi
    add edi, [eax + 4*ecx]
    add edi, [eax + 4*ecx + 4]
    add edi, [eax + 4*ecx - 4]
    mov edx, [img_width]
    add edx, ecx
    add edi, [eax + edx * 4]
    sub edx, [img_width]
    sub edx, [img_width]
    add edi, [eax + edx * 4]
    
    push eax
    mov eax,edi
    push ecx
    mov ecx, 5
    cdq
    div ecx
    pop ecx
    mov edi,eax
    pop eax
    
    
    mov edx,[eax + 4*ecx]
    push edi
    inc ecx
    cmp ecx, ebx
    jl pixel_by_pixel3 
;ultimul element    
    mov edx,[eax + 4*ecx]
    push edx
    inc ecx
    
    cmp esi, [img_height]
    jl for_loop
    
    add ebx, [img_width]
    ;si ultima linie
last_line:
    mov edx,[eax + 4*ecx]
    push edx
    inc ecx
    cmp ecx, ebx
    jl last_line 
    
    mov edx,[eax + 4*ecx]
    push edx

    ;parcurgem vectorul imagine invers
    ;si scriem in el valorile de pe stiva    
overWrite:
    pop edx
    mov [eax + 4*ecx],edx
    dec ecx
    cmp ecx, 0
    jge overWrite 
    
    leave
    ret



global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    
call word_search
    
;dupa ce gasim cuvantul       
print_ans:
    mov eax, ecx
    mov ebx, [img_width]   
    cdq
    div ebx
    push eax
    mul ebx
    mov ecx,ebx
    mov ebx, [img]
    ;daca edi este 2 mergem la rezolvarea pentru task2
    cmp edi, 2
    je task2_part2
    
    xor edi, edi
;printam linia pana la terminator    
print_loop:
    mov edx, [ebx + eax*4]
    inc eax
    dec ecx
    xor edx,esi
    cmp edx, 0
    je last_print_task1
    PRINT_CHAR edx
    cmp ecx,0
    jg print_loop
last_print_task1:
    NEWLINE
    PRINT_DEC 4,esi
    NEWLINE
    pop eax
    PRINT_DEC 4,eax
    NEWLINE
    jmp done 
            
solve_task2:
    ; TODO Task2
    mov edi,2
    call word_search
    
task2_part2:
    pop eax
    inc eax
    
    xor ecx,ecx
    mov ecx, eax
    mov ebx, [img_width]
    mul ebx
    mov ecx,eax
    mov ebx,[img]
    ;introducerea propozitiei
    ;C'est un proverbe francais.
    mov [ebx + 4*ecx], dword 'C'
    xor [ebx + 4*ecx], esi
    inc ecx
    
    mov [ebx + 4*ecx], dword "'"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword 'e'
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword 's'
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword 't'
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword " "
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword 'u'
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword 'n'
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword " "
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "p"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "r"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "o"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "v"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "e"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "r"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "b"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "e"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword " "
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "f"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "r"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "a"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "n"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "c"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "a"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "i"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "s"
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword "."
    xor [ebx + 4*ecx], esi
    inc ecx
    mov [ebx + 4*ecx], dword 0
    xor [ebx + 4*ecx], esi
    inc ecx
    ;calculam noua cheie
    mov eax,esi
    mov ebx,2
    mul ebx
    add eax,3
    mov ebx,5
    cdq
    div ebx
    sub eax,4
    push eax
    
    mov eax, [img_width]
    mov ebx, [img_height]
    mul ebx
    mov ebx,eax
    mov eax, [img]
    xor ecx, ecx
    pop edi
;recodam imaginea cu noua cheie
pixel_by_pixel2:
    mov edx,[eax + 4*ecx]
    xor edx,esi
    xor edx,edi
    mov [eax + 4*ecx],edx
    inc ecx
    cmp ecx, ebx
    jl pixel_by_pixel2
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
        
    
    jmp done
solve_task3:
    ; TODO Task3
    

    
    jmp done
solve_task4:
    ; TODO Task4
    jmp done
solve_task5:
    ; TODO Task5
    jmp done
solve_task6:
    ; TODO Task6
    call blur_image
    ;printam imaginea dupa blurat
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
      
    
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
