%A) Name:LUfact.m. Purpouse:If given matrix A and matrix b, returns the unknowns of
%the eqation1; \[A\]\*{x}={b}. To find {x}, LUfact(A,b) performs LU
%factorization to change the equation1 to equation2 and equation3;
%\[L\]\*{d}={b} and \[U\]\*{x}={d} respectively. By performing {d}\\\[U\], we can
%then find x values. To check, perform matrix multiplication of \[A\]\*{x} to
%see if the {b} matrix is returned.
%B) Program written:Feb. 23, 2013 Creator: Itai Axelrad
%C) Definitions of varibles: \[A\]=coefficents of the equation A(m,n)\*x(n)=b(n).
%{x}=varibles or unknowns of equation stated before. {b}=constants of the equation stated before.
%\[U\]=upper triangular matrix found with Guass Elimination of \[A'\]. \[L\]=lower
%triangular matrix of \[A'\] found with Guass Elimination. {d}=varibles of
%equation L(m,n)\*d(n)=b(n).
function \ [R \] = LUfact(A, b)
    \ [m, n \] = size(A); \ [z, x \] = size(b);

    if n ~= z, error('inner dimenstions need to match'), end;
        \ [L, U \] = lu(A);
        d = L \ \ b;
        R = U \ \ d;
        B = A \* R;

        if B ~= b, error('x values should return matrix b'), end;
            fprintf('       Ra            Rb             Rc              Rd         (kips)\\n')
            fprintf('%10.3f     %10.3f     %10.3f     %10.3f\\n', R')
        end
