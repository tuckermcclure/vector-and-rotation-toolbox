% Generic values
r     = coder.typeof(0, [3 1],   [0 1]);
theta = coder.typeof(0, [1 1],   [0 1]);
R     = coder.typeof(0, [3 3 1], [0 0 1]);
q     = coder.typeof(0, [4 1],   [0 1]);
p     = coder.typeof(0, [3 1],   [0 1]);
ea    = coder.typeof(0, [3 1],   [0 1]);
seq   = coder.typeof(uint8(1), [1 3]);
a     = coder.typeof(1);
f     = coder.typeof(4);

% Things to build:
build = {'aa2dcm',  {r, theta}; ...
         'aa2grp',  {r, theta, a, f}; ...
         'aa2q',    {r, theta}; ...
         'dcm2aa',  {R}; ...
         'dcm2ea',  {R, seq}; ...
         'dcm2q',   {R}; ...
         'ea2dcm',  {ea, seq}; ...
         'ea2q',    {ea, seq}; ...
         'grp2aa',  {p, a, f}; ...
         'grp2dcm', {p, a, f}; ...
         'grp2q',   {p, a, f}; ...
         'q2aa',    {q}; ...
         'q2dcm',   {q}; ...
         'q2ea',    {q, seq}; ...
         'q2grp',   {q, a, f}};

% Build everything.
for k = 1:size(build, 1)
    fprintf('Building %s...\n', build{k, 1});
    codegen('-config:mex', build{k, 1}, '-args', build{k, 2});
end
