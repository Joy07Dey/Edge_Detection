function [ZXZY] = pl_ed(IMG, filter, row, col, thld)
	x = filter; y = filter; DTHLD = thld;
    ZXZY = IMG;
    for i = x+1:col-x
        for j = y+1:row-y
            DMXPY = IMG((i-(x+1))*row+j+y);             
            DZXPY = IMG((i-x)*row+j+y);
            DPXPY = IMG(i*row+j+y);            
            if (j==y+1)
                DMXZY = IMG((i-(x+1))*row+j);
                DZXZY = IMG((i-x)*row+j);
                DPXZY = IMG(i*row+j);
            else
                DMXZY = DMXPY;
                DZXZY = DZXPY;
                DPXZY = DPXPY;
            end 
            if (j==y+1)
                DMXMY = IMG((i-(x+1))*row+j-y);
                DZXMY = IMG((i-x)*row+j-y);
                DPXMY = IMG(i*row+j-y);
            else
                DMXMY = DMXZY;
                DZXMY = DZXZY;
                DPXMY = DPXZY;
            end
            
            Diff = box_ed (DMXZY,  DPXZY,  DZXMY,  DZXPY,  DMXMY,  DPXPY,  DMXPY,  DPXMY);       
            
            if (Diff < DTHLD)
                ZXZY((i-x)*row+j) = 0;
            else
                ZXZY((i-x)*row+j) = Diff;
            end

        end
    end

end

function [Diff] = box_ed (DMXZY,  DPXZY,  DZXMY,  DZXPY,  DMXMY,  DPXPY,  DMXPY,  DPXMY)

            if (DMXZY < DPXZY)
                DLR = DPXZY - DMXZY;
            else
                DLR = DMXZY - DPXZY;
            end

            if (DZXMY < DZXPY)
                DUD = DZXPY - DZXMY;
            else
                DUD = DZXMY - DZXPY;
            end

            if (DMXMY < DPXPY)
                DD1 = DPXPY - DMXMY;
            else
                DD1 = DMXMY - DPXPY;
            end

            if (DMXPY < DPXMY)
                DD2 = DPXMY - DMXPY;
            else
                DD2 = DMXPY - DPXMY;
            end
            
            Diff = (DLR + DUD + DD1 + DD2);
end

