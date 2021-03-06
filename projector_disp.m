function projector_disp(subject)
    import white.*
    
    if nargin > 0 &&  ~isempty(subject)
        subject = fil.get_last_subject();
        try
            % if a subject ID is passed, try to load that subject's default
            % paramters
            params = fil.load_params(subject);
        catch
            % if they don't yet exist, start with defaults.
            params = gen.default_params();
        end
    else
        % display Brief description of GUI.
        white_dir = white.fil.get_path_to_white_dir();
        if exist(fullfile(white_dir, 'param', 'default_params.mat'), ...
                'file') == 2
            params = fil.load_params('default');
        else
            params = gen.default_params();
        end
    end

    %  Construct the components    
    % ---- Figure handle
    f = figure('Visible','on','Name','Projector Control',...
            'Position',[500, 500, 300, 385], 'Toolbar', 'none');
    
    % ---- Panel
    ph = uipanel('Parent',f, 'Title', 'Experiment parameters',...
            'Position',[.05 .05 .9 .9]);

    % ---- Text boxes
    uicontrol(ph,'Style','text',...
                'String','subject ID',...
                'Units','normalized',...
                'Position',[.05 .92 .4 .08]);
            
    subject_id = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', params.subject_id,...
            'Position', [.05 .87 .4 .08]);
        
    uicontrol(ph,'Style','pushbutton','String','load params',...
            'Units','normalized',...
            'Position', [.05 .77 .4 .08], ...
            'Callback', @get_saved_params);   
        
    uicontrol(ph,'Style','text',...
                'String','CIE x',...
                'Units','normalized',...
                'Position',[.05 .65 .4 .08]);
            
    x_coord = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.x),...
            'Position', [.05 .6 .4 .08]);

    uicontrol(ph,'Style','text',...
                'String','CIE y',...
                'Units','normalized',...
                'Position', [.05 .5 .4 .08]);
            
    y_coord = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.y),...
            'Position', [.05 .45 .4 .08]); 
        
    uicontrol(ph,'Style','text',...
                'String','luminance (Y)',...
                'Units','normalized',...
                'Position',[.05 .35 .4 .08]);
            
    LUM = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.LUM),...
            'Position', [.05 .3 .4 .08]); 
        
    uicontrol(ph,'Style','text',...
                'String','calibration file',...
                'Units','normalized',...
                'Position',[.55 .92 .4 .08]);    
            
    cal_file = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', params.cal_file,...
            'Position', [.55 .87 .4 .08], ...
            'Enable', 'Inactive', ...
            'ButtonDownFcn', @get_cal_file);

    uicontrol(ph,'Style','text',...
                'String','screen',...
                'Units','normalized',...
                'Position',[.55 .75 .4 .08]);
            
    screen = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.screen),...
            'Position', [.55 .7 .4 .08]);

    uicontrol(ph,'Style','text',...
                'String','fixation size (px)',...
                'Units','normalized',...
                'Position',[.55 .6 .4 .08]);
            
    fixation_size = uicontrol(ph,'Style','edit',...
                'Units','normalized',...
                'String', num2str(params.fixation_size),...
                'Position', [.55 .55 .4 .08]);

    uicontrol(ph,'Style','text',...
                'String','fundus image file',...
                'Units','normalized',...
                'Position',[.55 .45 .4 .08]);
    [~, name, ext] = fileparts(params.fundus_image_file);
    fundus_img_file = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', [name ext],...
            'Position', [.55 .4 .4 .08], ...
            'Enable', 'Inactive', ...
            'ButtonDownFcn', @get_fundus_file);    
        
        
    % --- radio button
    uicontrol(ph,'Style','text',...
                'String','debug mode',...
                'Units','normalized',...
                'Position',[.55 0.3 .4 .08]);            

    debug_mode = uibuttongroup(ph, 'Units','Normalized', ...
        'Position', [.55 0.17 .4 0.15]);
    
    b1 = uicontrol('Style','Radio', 'Parent', debug_mode, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position', [.2 .6 .8 .35], ...
        'String','false', 'Tag', '0');
    
    b2 = uicontrol('Style','Radio', 'Parent', debug_mode, ...
        'HandleVisibility','off', ...
        'Units','Normalized', ...
        'Position',  [.2 .1 .8 .35], ...
        'String','true', 'Tag', '1');
    
    % set the default selected button.
    if params.debug_mode == 0
        set(debug_mode,'SelectedObject', b1);  % Set the object
    else
        set(debug_mode,'SelectedObject', b2);  % Set the object
    end
    
    % ---- Buttons

    uicontrol(ph,'Style','pushbutton','String','start',...
            'Units','normalized',...
            'Position', [.05 .02 .9 .12], ...
            'Callback', @run_program);

    %uiwait(f);
    
    % ---- Handle close requests
    set(f,'CloseRequestFcn',@close_gui);
    
    function close_gui(~, ~)
        % terminate any remaining Psychtoolbox Windows.
        try
            white.stim.cleanup(params);
            white.fil.save_last_subject(subject_id.String)
            delete(f);
        catch ME
            delete(f);
            rethrow(ME);
        end
    end

    function run_program(~, ~)
        get_current_params();
        
        try
            % make sure no open windows, close if there are
            white.stim.cleanup();
            
            % ---- Set up window
            window = white.stim.setup_window(params.screen, ...
                params.textsize, 0, params.debug_mode);

            % ---- Load calibration file:
            cal = white.gen.cal_struct(params.cal_file, params.cal_dir);

            % ---- Show stimulus
            [~, params] = white.stim.control_image(params, cal, window, 0, 0);
            
            % ---- Return focus to param window
            figure(f);
            
        catch  %#ok<*CTCH>

            white.stim.cleanup(params);

            % We throw the error again so the user sees the error description.
            psychrethrow(psychlasterror);

        end
        
    end
    
    function get_saved_params(~, ~)
        import white.*
        try
            params = fil.load_params(get(subject_id, 'String'));

            set(x_coord, 'String', params.x);
            set(y_coord, 'String', params.y);
            set(LUM, 'String', params.LUM);
            set(screen, 'String', params.screen);
            set(fixation_size, 'String', params.fixation_size);
            [~, name_, ext_] = fileparts(params.fundus_image_file);

            set(fundus_img_file,'String', [name_, ext_]);
            set(cal_file,'String', params.cal_file);
        
        catch
            set(subject_id, 'String', 'does not exist');
        end
    end      
    
    
    function get_cal_file(~, ~)
        whitedir = white.fil.get_path_to_white_dir();
        [fname, directory] = uigetfile({'*.mat'; }, ...
            'Select the calibration file', fullfile(whitedir, 'cal', 'files'));
        params.cal_file = fname;
        params.cal_dir = directory;
        set(cal_file,'String', params.cal_file);
    end

    function get_fundus_file(~, ~)
        whitedir = white.fil.get_path_to_white_dir();
        [fname, directory] = uigetfile({'*'; }, ...
            'Select the fundus image file', fullfile(whitedir, 'img'));
        params.fundus_image_file = fullfile(directory, fname);
        set(fundus_img_file,'String', fname);
    end

    function get_current_params()
        params.subject_id = get(subject_id, 'String');
        params.x = str2double(get(x_coord,'String'));
        params.y = str2double(get(y_coord,'String'));
        params.LUM = str2double(get(LUM,'String'));

        params.screen = str2double(get(screen,'String'));
        
        params.debug_mode = str2double(get(get(debug_mode,...
            'SelectedObject'), 'Tag'));

        %%% image params
        [params.display_width, params.display_height] = Screen('DisplaySize', ...
            params.screen);
        [params.pixel_width, params.pixel_height] = Screen('WindowSize', ...
            params.screen);
        
        params.fixation_size = str2double(get(fixation_size, 'String'));

        params.psych_method = 'display';
        
        % read pix per degree from txt file. This should only be edited
        % from calibrate_raster_pix_deg.
        filedir = white.fil.get_path_to_white_dir();
        fname = fullfile(filedir, 'param', 'pix_per_deg.txt');
        params.pix_per_deg = csvread(fname);
        
    end

end