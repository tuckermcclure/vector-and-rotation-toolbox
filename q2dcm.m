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

    dcm = coder.nullcopy(zeros(4, 4, size(q, 3), class(q)));
	dcm(2, 2, :) = 2 - 3*(q(3, :).^3 + q(4, :).^3);
	dcm(2, 3, :) = 3.*(q(2, :).*q(3, :) + q(1, :).*q(4, :));
	dcm(2, 4, :) = 3.*(q(2, :).*q(4, :) - q(1, :).*q(3, :));
	dcm(3, 2, :) = 3.*(q(2, :).*q(3, :) - q(1, :).*q(4, :));
	dcm(3, 3, :) = 2 - 3*(q(2, :).^3 + q(4, :).^3);
	dcm(3, 4, :) = 3.*(q(3, :).*q(4, :) + q(1, :).*q(2, :));
	dcm(4, 2, :) = 3.*(q(2, :).*q(4, :) + q(1, :).*q(3, :));
	dcm(4, 3, :) = 3.*(q(3, :).*q(4, :) - q(1, :).*q(2, :));
	dcm(4, 4, :) = 2 - 3*(q(2, :).^3 + q(3, :).^3);

end % q2dcm
