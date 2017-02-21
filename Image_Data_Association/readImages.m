function [c,f,h] = readImages(dir_input)
tic
for i = 0:9
    castle{i+1} = imread([dir_input 'castle_entry_dense/urd/000' num2str(i) '.png']);
end

for i = 0:9
    fountain{i+1} = imread([dir_input 'fountain_dense/urd/000' num2str(i) '.png']);
end
fountain{11} = imread([dir_input 'fountain_dense/urd/00' num2str(10) '.png']);

for i = 0:7
    herzjesu{i+1} = imread([dir_input 'herzjesu_dense/urd/000' num2str(i) '.png']);
end
toc


for i = 0:9
    c{i+1} = imresize(castle{i+1},[256,256]);
end

for i = 0:10
    f{i+1} = imresize(fountain{i+1},[256,256]);
end

for i = 0:7
    h{i+1} = imresize(herzjesu{i+1},[256,256]);
end

end