function params = exp(params)
    % experiment Brief description of GUI.

    %  Construct the components
    
    % ---- Figure handle
    f = figure('Visible','on','Name','parameters',...
            'Position',[500, 500, 550, 385], 'Toolbar', 'none');
    
    % ---- Panel
    ph = uipanel('Parent',f, 'Title', 'Experiment parameters',...
            'Position',[.05 .05 .9 .9]);

    % ---- Text boxes
    uicontrol(ph,'Style','text',...
                'String','Subject ID',...
                'Units','normalized',...
                'Position',[.05 .9 .25 .10]);
            
    subject_ID = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', params.subject,...
            'Position', [.05 .85 .25 .10]);

    uicontrol(ph,'Style','text',...
                'String','# of colors',...
                'Units','normalized',...
                'Position', [.05 .75 .25 .10]);
            
    ncolors = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.ncolors),...
            'Position', [.05 .7 .25 .10]); 
        
    uicontrol(ph,'Style','text',...
                'String','comments',...
                'Units','normalized',...
                'Position',[.05 .6 .25 .10]);
            
    comment = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', '',...
            'Position', [.05 .55 .25 .10]); 
        
    uicontrol(ph,'Style','text',...
                'String','Luminance (cd/m^2)',...
                'Units','normalized',...
                'Position',[.35 .9 .25 .10]);
            
    LUM = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.LUM),...
            'Position', [.35 .85 .25 .10]);

    uicontrol(ph,'Style','text',...
                'String','rho (xyz distance)',...
                'Units','normalized',...
                'Position',[.35 .75 .25 .10]);
            
    RHO = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.RHO),...
            'Position', [.35 .7 .25 .10]); 

    uicontrol(ph,'Style','text',...
                'String','# repeats',...
                'Units','normalized',...
                'Position',[.35 .6 .25 .10]);
            
    nrepeats = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.nrepeats),...
            'Position', [.35 .55 .25 .10]); 

        
    uicontrol(ph,'Style','text',...
                'String','calibration file',...
                'Units','normalized',...
                'Position',[.65 .9 .25 .10]); 
            
    cal_file = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.cal_file),...
            'Position', [.65 .85 .25 .10], ...
            'Enable', 'Inactive', ...
            'ButtonDownFcn', @get_cal_file);

    uicontrol(ph,'Style','text',...
                'String','pause time (s)',...
                'Units','normalized',...
                'Position',[.65 .75 .25 .10]);
            
    pause_time = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.pause_time),...
            'Position', [.65 .7 .25 .10]); 
        
    uicontrol(ph,'Style','text',...
                'String','screen',...
                'Units','normalized',...
                'Position',[.65 .6 .25 .10]);
            
    screen = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.screen),...
            'Position', [.65 .55 .25 .10]);
        
        
    % ---- Radio buttons
    uicontrol(ph,'Style','text',...
            'String','annulus',...
            'Units','normalized',...
            'Position',[.05 .45 .25 .07]);  
        
    stimulus_shape = uibuttongroup(ph, 'Units','Normalized', ...
        'Position', [.05 .3 .25 .15]);
    
    uicontrol('Style','Radio', 'Parent', stimulus_shape, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position', [.1 .6 .8 .35], ...
        'String','rectangle', 'Tag','rectangle');

    uicontrol('Style','Radio', 'Parent', stimulus_shape, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position',  [.1 .1 .8 .35], ...
        'String','circle', 'Tag','circle');
    
    uicontrol(ph,'Style','text',...
                'String','constant stim',...
                'Units','normalized',...
                'Position',[.35 .45 .25 .07]);
            
    constant_stim = uibuttongroup(ph, 'Units','Normalized', ...
        'Position', [.35 .3 .25 .15]);
    
    uicontrol('Style','Radio', 'Parent', constant_stim, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position', [.1 .6 .8 .35], ...
        'String','true', 'Tag', '1');
    
    uicontrol('Style','Radio', 'Parent', constant_stim, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position',  [.1 .1 .8 .35], ...
        'String','false', 'Tag', '0');

    
    uicontrol(ph,'Style','text',...
                'String','color space',...
                'Units','normalized',...
                'Position',[.65 .45 .25 .07]);
            
    color_space = uibuttongroup(ph, 'Units','Normalized', ...
        'Position', [.65 .3 .25 .15]);
    
    uicontrol('Style','Radio', 'Parent', color_space, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position', [.1 .6 .8 .35], ...
        'String','Luv', 'Tag', 'Luv');
    
    uicontrol('Style','Radio', 'Parent', color_space, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position',  [.1 .1 .8 .35], ...
        'String','xyY', 'Tag', 'xyY');

    
    uicontrol(ph,'Style','text',...
                'String','method',...
                'Units','normalized',...
                'Position',[.65 .2 .25 .07]);
            
    psych_method = uibuttongroup(ph, 'Units','Normalized', ...
        'Position', [.65 .05 .25 .15]);
    
    uicontrol('Style','Radio', 'Parent', psych_method, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position', [.1 .6 .8 .35], ...
        'String','adjustment', 'Tag', 'adjustment');
    
    uicontrol('Style','Radio', 'Parent', psych_method, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position',  [.1 .1 .8 .35], ...
        'String','forced choice', 'Tag', 'forced choice');
    

    % ---- Buttons
    uicontrol(ph,'Style','pushbutton','String','start',...
            'Units','normalized',...
            'Position', [.35 .05 .25 .15], ...
            'Callback', 'uiresume(gcbf)');

    uicontrol(ph,'Style','pushbutton','String','plot stimuli',...
            'Units','normalized',...
            'Position', [.05 .05 .25 .15], ...
            'Callback', @plot_stimuli);
        
    uiwait(f);
    
    get_current_params();
    
    function get_current_params()
        params.subject = get(subject_ID,'String');
        params.stimulus_shape = get(get(stimulus_shape, ...
            'SelectedObject'), 'Tag');
        params.constant_stim = str2double(get(get(constant_stim, ...
            'SelectedObject'), 'Tag'));
        params.LUM = str2double(get(LUM,'String'));
        params.RHO = str2double(get(RHO,'String'));
        params.ncolors = str2double(get(ncolors,'String'));
        params.nrepeats = str2double(get(nrepeats,'String'));
        params.cal_file = get(cal_file,'String');
        params.pause_time = str2double(get(pause_time,'String'));
        params.screen = str2double(get(screen,'String'));
        params.color_space = get(get(color_space, 'SelectedObject'), ...
            'Tag');
         params.psych_method = get(get(psych_method, 'SelectedObject'), ...
            'Tag');       
        %%% recompute
        params.ntrials = params.ncolors * params.nrepeats;
        
        %%% image params
        [params.display_width, params.display_height] = Screen('DisplaySize', ...
            params.screen);
        [params.pixel_width, params.pixel_height] = Screen('WindowSize', ...
            params.screen);

        if ~strcmp(params.psych_method, 'adjustment')
            params.img_offset_width = 0;
            params.img_offset_height = 0;
        end
        
        params.comment = comment;
    end

    function get_cal_file(~, ~)
        [fname, directory] = uigetfile({'*.mat'; }, ...
            'Select the calibration file', './cal/files/');
        params.cal_file = fname;
        params.cal_dir = directory;
        set(cal_file,'String', params.cal_file);
    end

    function plot_stimuli(~, ~)
        uiresume(f);
        get_current_params();
        white.plot.stimuli({'blue' 'yellow' 'white'}, params, 2);
        uiwait(f);
    end


    close all;

end