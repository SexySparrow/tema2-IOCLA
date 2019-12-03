%include "/home/student/iocla-tema2-resurse/include/io.inc"

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
    
    ; TODO Task1
    mov eax, [img_width]
    mov ebx, [img_height]
    mul ebx
    mov ebx,eax
    mov eax, [img]
    xor ecx, ecx
    xor esi, esi
brut_force:
    inc esi
    xor ecx,ecx    
pixel_by_pixel:
    mov edx,[eax + 4*ecx]
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

back:
    pop ecx
    jmp pixel_by_pixel
    
       
print_ans:
    mov eax, ecx
    mov ebx, [img_width]   
    cdq
    div ebx
    push eax
    mul ebx
    mov ecx,ebx
    mov ebx, [img]
    cmp edi, 2
    je task2_part2
    
    xor edi, edi
    
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
    jmp solve_task1
    
task2_part2:
    pop eax
    inc eax
    
    xor ecx,ecx
    mov ecx, eax
    mov ebx, [img_width]
    mul ebx
    mov ecx,eax
    mov ebx,[img]
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
    