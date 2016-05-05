function dcm = q2dcm(q)

% q2dcm
%
% Convert a unit quaternion representing a rotation into a corresponding
% direction cosine matrix. This is vectorized to accept 1-by-n quaternions,
% returning 4-by-4-by-n DCMs.
%
% v_B = T_BA * v_A = q2dcm(q_BA) * v_A

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    dcm = coder.nullcopy(zeros(3, 3, size(q, 2), class(q)));
	dcm(1, 1, :) = 1 - 2*(q(3, :).^2 + q(4, :).^2);
	dcm(1, 2, :) = 2.*(q(2, :).*q(3, :) + q(1, :).*q(4, :));
	dcm(1, 3, :) = 2.*(q(2, :).*q(4, :) - q(1, :).*q(3, :));
	dcm(2, 1, :) = 2.*(q(2, :).*q(3, :) - q(1, :).*q(4, :));
	dcm(2, 2, :) = 1 - 2*(q(2, :).^2 + q(4, :).^2);
	dcm(2, 3, :) = 2.*(q(3, :).*q(4, :) + q(1, :).*q(2, :));
	dcm(3, 1, :) = 2.*(q(2, :).*q(4, :) + q(1, :).*q(3, :));
	dcm(3, 2, :) = 2.*(q(3, :).*q(4, :) - q(1, :).*q(2, :));
	dcm(3, 3, :) = 1 - 2*(q(2, :).^2 + q(3, :).^2);

%     dcm = coder.nullcopy(zeros(3, 3, size(q, 2), class(q)));
% 	dcm(1, 1, :) = 1 - 2*(q(2, :).^2 + q(3, :).^2);
% 	dcm(1, 2, :) = 2.*(q(1, :).*q(2, :) + q(4, :).*q(3, :));
% 	dcm(1, 3, :) = 2.*(q(1, :).*q(3, :) - q(4, :).*q(2, :));
% 	dcm(2, 1, :) = 2.*(q(1, :).*q(2, :) - q(4, :).*q(3, :));
% 	dcm(2, 2, :) = 1 - 2*(q(1, :).^2 + q(3, :).^2);
% 	dcm(2, 3, :) = 2.*(q(2, :).*q(3, :) + q(4, :).*q(1, :));
% 	dcm(3, 1, :) = 2.*(q(1, :).*q(3, :) + q(4, :).*q(2, :));
% 	dcm(3, 2, :) = 2.*(q(2, :).*q(3, :) - q(4, :).*q(1, :));
% 	dcm(3, 3, :) = 1 - 2*(q(1, :).^2 + q(2, :).^2);

end % q2dcm
