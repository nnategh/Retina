function junk03()
h = plot(peaks);
set(gca, 'buttondownfcn', @clicky);

function clicky(~, ~, ~)
disp('clicky');