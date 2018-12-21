function [rand] = generate_n_rand(len, n)
        rand = zeros(n,1);
        
        i = 1;
        while i <= n
            cur = randi([1 len],1,1);
            
            % make sure we're choosing distinct point
            isSeen = false;
            for k=1:i-1
                if rand(k) == cur
                    isSeen = true;
                end
            end
            
            if ~isSeen
                rand(i) = cur;
                i = i + 1;
            end
        end
end

