function points_index = associate_rgb_space(bc2_avg_vector,centroids)
    %{
    v1 = [1 2 3]; v2 = [1 2 0];
    dist = sqrt(sum((v1-v2).^2))
    %}

    %{
    ideia do codigo: 
    aplica-se, ao frame em que os peixes v�o ser rastreados, blob_colours_2. 
    receber o resultado de blob_colours_2.m (bc2_avg_vector)
    e um dos resultados da calcula_centroids_cov_rgb.m (centroids).

    o �ndice do centroide � atribu�do a cada elemento do bc2_avg_vector. Isto
    �, se o primeiro RGB do bc2_avg_vector estiver mais perto do 2o centr�ide,
    o primeiro elemento do vetor centroids_index � 2.
    %}
    
    mat_bc2_avg_v = cell2mat(bc2_avg_vector);
    D = pdist2(mat_bc2_avg_v, centroids); 
    [~,I] = min(D');
    points_index = I';

%{
    if we use the code as:
    D = pdist2(mat_bc2_avg_v, centroids); 
    Then we can be sure that the columns are related to the centroids.
    What does it mean? Each line refers to a point to be labeled. If, for
    a line, the second column has smaller value the first column, then the
    point is closer to the second cluster. This point should be labeled
    '2'.
%}       
end