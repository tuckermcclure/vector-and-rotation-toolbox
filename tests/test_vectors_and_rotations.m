% Add the 'tests' directory to the path and then run this script from the
% top-level directory (<here>/..).

clc;

rebuild = true;

source = 'tests';
target = 'mex';
% target = source;
this   = fileparts(mfilename('fullpath'));
if ~exist(target, 'dir')
    mkdir(target);
end
addpath(this, source);
addpath(this, target);

% Define the tests.
tests = {'MRPUnitTests'; ...
         'QuaternionUnitTests'; ...
         'RotationConversionUnitTests'; ...
         'VectorUnitTests'};

% Run the tests.
stop_after_tests = false;
for k = 1:length(tests)
    test = eval([tests{k} '()']);
    result = run(test);
    if any([result.Failed])
        stop_after_tests = true;
    end
end

% Stop if the original tests didn't work.
if stop_after_tests
    return;
end

% Build everything to MEX.
if rebuild
    built = build_vectors_and_rotations([], target);
else
    files = dir(['*_mex.' mexext()]); %#ok<UNRCH>
    files = {files.name}.';
    built = regexp(files, ['\w+(?=_mex\.' mexext '$)'], 'match');
    built = cellfun(@(c) c{1}, built, 'UniformOutput', false);
end

% Copy the tests to a new place.
new_tests = cell(size(tests));
for k = 1:length(tests)
	new_tests{k} = [fullfile(target, tests{k}) 'Mex.m'];
    copyfile([fullfile(source, tests{k}) '.m'], new_tests{k});
    find_and_replace(new_tests{k}, tests{k}, [tests{k} 'Mex']);
end

% Replace each function with its _mex equivalent in each of the new files.
for k = 1:length(built)
    find_and_replace(new_tests, ['(?<=\W)(' built{k} ')(?=\W)'], '$1_mex');
end

% And run the tests.
for k = 1:length(tests)
    test = eval([tests{k} 'Mex()']);
    run(test);
end
