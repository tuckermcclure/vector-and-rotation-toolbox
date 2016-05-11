function q_CB = qdiff(q_CA, q_BA)

% Copyright 2016 An Uncommon Lab

%#codegen

    % q_CA = qcomp(q_CA, qinv(q_BA)), but this is faster.
    q_CB = [-q_CA(4,:).*q_BA(1,:) - q_CA(3,:).*q_BA(2,:) + q_CA(2,:).*q_BA(3,:) + q_CA(1,:).*q_BA(4,:); ...
             q_CA(3,:).*q_BA(1,:) - q_CA(4,:).*q_BA(2,:) - q_CA(1,:).*q_BA(3,:) + q_CA(2,:).*q_BA(4,:); ...
            -q_CA(2,:).*q_BA(1,:) + q_CA(1,:).*q_BA(2,:) - q_CA(4,:).*q_BA(3,:) + q_CA(3,:).*q_BA(4,:); ...
             q_CA(1,:).*q_BA(1,:) + q_CA(2,:).*q_BA(2,:) + q_CA(3,:).*q_BA(3,:) + q_CA(4,:).*q_BA(4,:)];

end % qdiff

