function mex_only = test_mex_only(name)
    mex_only = ~isempty(regexp(name, 'Mex$', 'once'));
end
