require "math"


function print_vec(x)
    print(unpack(x))
    print()
end

function print_mat(A)
    for i=1, #A do
      print(unpack(A[i]))
      print()
    end
end

--function mat2tex(A)
  

function Substi_R(A,b)
    x = {}
    n = #b
    x[n] = b[n]/A[n][n]
  
    for i = n-1, 1, -1 do
        sum = 0
        for j =i+1, n do
          sum = sum + A[i][j]*x[j]
        end
        x[i] = (b[i]-sum)/A[i][i]
    end
    return x
end

function GaussPerm(A, b)
    Ak = A
    bk = b
    n = #b
    print("A_1 =")
    print_mat(Ak)
    print("b_1 =")
    print_vec(bk)
    
    for k = 1, n-1 do
        Ak1 = Ak
        bk1 = bk
    
        print("k = "..k)
    
        if Ak[k][k] == 0 then --null pivot; find another
            imax = k
            for l = imax, n do
                if math.abs(A[l][k]) > math.abs(A[imax][k]) then
                    imax = l
                end
            end
            print("Null pivot : permuting lines "..k.." and "..imax)
            Atemp = Ak[k]
            btemp = bk[k]
            Ak[k] = Ak[imax]
            bk[k] = bk[imax]
            Ak[imax] = Atemp
            bk[imax] = btemp
            
            print("A_"..k.." =")
            print_mat(Ak)
            print("b_"..k.." =")
            print_vec(bk)
        end
    
        for i = k+1, n do
            bk1[i] = bk[i] - ((Ak[i][k]*b[k])/Ak[k][k])
            for j = k+1, n do
                Ak1[i][j] = Ak[i][j] - ((Ak[i][k]*Ak[k][j])/Ak[k][k])
            end
            
            for j = 1, k do
                Ak1[i][j] = 0
            end
        end
        Ak = Ak1
        bk = bk1
        print("A_"..(k+1).." =")
        print_mat(Ak)
        print("b_"..(k+1).." =")
        print_vec(bk)
    end
    return Substi_R(Ak,bk)
end



A = { {2.4, 1.2, 1.7, 0.002209},
      {0.3, 3.0, 1.0, 0.002209},
      {1.4, 2.7, 0.9, 0.002209},
      {1.6, 1.9, 2.0, 0.002209} }
    
b = {2.88226035, 1.10539598, 1.71125752, 2.64420248}

x = GaussPerm(A,b)
print("x =")
print_vec(x)