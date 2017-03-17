function [depth_table] = measure_depth(min, max, ref)
    Pts = [min(1), min(1), min(1), min(1), max(1), max(1), max(1), max(1);%x
           min(2), min(2), max(2), max(2), min(2), min(2), max(2), max(2);%y
           min(3), max(3), min(3), max(3), min(3), max(3), min(3), max(3);%z
                 1,     1,      1,      1,      1,      1,      1,     1];
    depth_table = [ref.Rotation ref.T] * Pts;
end
