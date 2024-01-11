class Algo


    $arr = [10, 20, 30, 40, 50, 60, 70]
    $arr1 = [10, 120, 30, 140, 50, 160, 170]


    # Sequential Search Entry
    def self.sequential_search
        l= $arr.length
        x= 20
        for i in 0..l do
           if $arr[i] == x
                return i
           end
        end
        return -1


    end


    # binary Search Entry
    def self.binary_search(x)
        n= $arr.length
        
        puts "n #{n} x is #{x} #{$arr[n-1]}"
        if n == 0 or x > $arr[n-1]
            return n+1
        else
            i = 0
            j = n-1
            return binrec($arr, i, j, x)
        end 


    end

    # binary Search Recursion
    def self.binrec(arr, i, j, x)
        puts "#{arr} and #{x}, i #{i} , j #{j}"
        if i == j
            return i
        end
        k = ( i + j ) / 2
        puts k
        if x <= arr[k]
             binrec(arr , i , k , x)
        else
            binrec(arr , k+1 , j , x)
        end
    end


    # binary Search Iterator
    def self.biniter(x)
        n= $arr.length
        if n == 0 or x > $arr[n-1]
            return n+1
        end
        i= 0
        j= n-1
        while i < j 
            k = ( i + j ) / 2
            if x <= $arr[k] 
                j = k
            else
                i = k + 1               
            end
        end
        return i
    end


     

    #Fibonaci

    def self.fibo(n)

        if n <= 1
            return n
        else

            return (fibo(n-1)+fibo(n-2))

        end

    end



     # Entry Point to Quick Sort
     def self.sort(arr)

        puts "#{arr}"
       
        $arr1 =arr 
        
        p= 0
        r= $arr1.length - 1
        puts "Unsorted Array #{$arr1}  "
        quick_sort($arr1, p, r)

        puts "Sorted Array #{$arr1}  "


    end


    def self.quick_sort(arr, p, r)
       # puts " inside quick_sort #{arr} and p is #{p} and r is #{r}"
        if p < r
            q = partition(arr, p, r)
            quick_sort(arr, p, q-1)
            quick_sort(arr, q+1, r)
        end

    end

    # Quick Sort Partition function
    def self.partition(arr, p, r)
        #puts " inside partition #{arr} and p is #{p} and r is #{r}"
        x = $arr1[r]
       
        i = p - 1 
        k = r - 1
        for j in p..k do

            if $arr1[j] < x
                i = i + 1
                temp = $arr1[i]
                $arr1[i] =  $arr1[j]
                $arr1[j] = temp

            end

        end
        temp = $arr1[i+1]
        $arr1[i+1] = $arr1[r]
        $arr1[r] = temp



        return i + 1
        

    end

   


    

end