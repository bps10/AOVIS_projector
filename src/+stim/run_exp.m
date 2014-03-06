function run_exp(params)

import gen.gen_hue_order
import fil.check_for_data_dir
import stim.setup_window
import stim.show_stimulus_set
import stim.show_stimulus
import stim.cleanup

if strcmp(params.psych_method, 'forced choice')
    % ---- Set up window
    [window, oldVisualDebugLevel, oldSupressAllWarnings] = setup_window(...
        params.screen);

    % ---- Randomize the order of blue, yellow settings.
    [first, second] = gen_hue_order();
    try
        % ---- Present first set of stimuli
        [params, ~] = show_stimulus_set(window, params, first);

        % ---- Present second set of stimuli
        [params, ~] = show_stimulus_set(window, params, second);

        % ---- Present achromatic stimuli
        [params, xyz] = show_stimulus_set(window, params, 'white');

        % ---- Show final stimulus
        show_stimulus([xyz(1) xyz(2) params.LUM]', params);

        cleanup(oldVisualDebugLevel, oldSupressAllWarnings);

    catch  %#ok<*CTCH>

        cleanup(oldVisualDebugLevel, oldSupressAllWarnings);
        psychrethrow(psychlasterror);
    end

elseif strcmp(params.psych_method, 'adjustment')
    data_record = zeros(params.ntrials, 5);
    
    xyz = show_stimulus([0.1825 0.3225 params.LUM], params, 0);
    
end

% ---- Print xyz result for white
disp('xyz:')
disp(xyz);
disp('uv:');
disp(xyTouv(xyz(1:2)));
