classdef CalciumGUI < handle
    properties
        Figure            % figure handle
        nPlot             % Number plots
        Name              % name of gui figure
        SliderPanel       % panel handle that contains ui elements
        ResetButton       % reset button handle
        ExportButton      % parameter export button handle
        Axis              % axis handles
        SliderCount       % number of sliders
        SliderHandle      % slider handles
        SliderNameList    % slider parameter names 
        Parameters        % array of current slider values
        ParamSetStructure % P structure used as model input
        InitialParam      % intial slider values
        StateVar          % current state variables
        NonStateVar       % current non-state variables
    end
    
    methods
        
        % Constructor
        function obj = CalciumGUI(Name)
            obj.Name = Name;
            obj.SliderCount = 0;
            obj.nPlot = 4;
            obj.SliderNameList = cell.empty;
            obj.Figure = figure('Visible','on','Name',obj.Name);
            movegui(obj.Figure,'center');
        end
        
        % Panel that will contain parameter sliders
        function obj = createpanel(obj)
            obj.SliderPanel.Controls = uipanel('Title','Parameter Control',...
                'FontSize',10,'FontWeight','bold','Position',[.80 0.1 0.20 0.9]);
        end
        
        function obj = addresetbutton(obj)
            obj.ResetButton = ...
                uicontrol('Style','pushbutton',...
                'String','RESET',...
                'FontSize',10,...
                'Units','normalized',...
                'Position',[0.80 0 0.0666 0.075],...
                'Callback',@obj.resetgui);
        end
        
        % Callback function for reset button
        function obj = resetgui(obj,~,~)
            nVal = length(obj.SliderHandle.s);
            obj.Parameters = zeros(nVal,1);
            for i = 1:nVal
                obj.SliderHandle.s(i).Value = obj.InitialParam(i);
            end
            updateaxes(obj);
        end
        
        function obj = addexportparambutton(obj)
            obj.ExportButton = ...
                uicontrol('Style','pushbutton',...
                'String','EXPORT',...
                'FontSize',10,...
                'Units','normalized',...
                'Position',[0.8666 0 0.0666 0.075],...
                'Callback',@obj.exportparam);
        end
        
        function obj = exportparam(obj,~,~)
            ParamSet = obj.Parameters;
            path = uigetdir(pwd,'Select path for output');
            name = char(inputdlg("Enter parameter set name"));
            save([path '\' name],'ParamSet') 
        end
        
        function obj = addimportparambutton(obj)
            obj.ExportButton = ...
                uicontrol('Style','pushbutton',...
                'String','IMPORT',...
                'FontSize',10,...
                'Units','normalized',...
                'Position',[0.9332 0 0.0666 0.075],...
                'Callback',@obj.importparam);
        end
        
        function obj = importparam(obj,~,~)
            [pSet,path] = uigetfile;
            obj.Parameters = load([path pSet]);
            
            for i = 1:obj.SliderCount
                obj.SliderHandle.s(i,1).Value = ...
                    obj.Parameters.ParamSet(i);
            end
            
            updateaxes(obj)
        end
        
        
        % Define the initial parameters based on starting slider values
        function obj = initstate(obj)
            obj.InitialParam = obj.Parameters;
            updateaxes(obj);
        end

        % Create the axes; Position = [left bottom width height]
        function obj = createplot(obj)
            nRow = 3;
            nCol = 2;
            height = 1/nRow-0.05;
            width = 0.8/nCol-0.05;
            iplot = 0;
            for irow = 1:nRow
                for icol = 1:nCol
                    iplot = iplot + 1;
                     obj.Axis.h(iplot) = axes('Units','normalized',...
                    'Position',...
                    [0.03+1.1*(icol-1)*width 1-1.05*(irow*height) width height]);
                end
            end
            
        end
        
        % Define a slider
        function obj = defineslider(obj,sName,sMin,sMax,sInitVal)
            obj.SliderCount = obj.SliderCount + 1;
            obj.SliderHandle.s(obj.SliderCount,1) = ...
                uicontrol('Parent',obj.SliderPanel.Controls,...
                'Style','slider',...
                'String',sName,...
                'Min',sMin,'Max',sMax,'Value',sInitVal,...
                'SliderStep',[0.01 0.1],...
                'Units','normalized',...
                'Callback',@obj.updateaxes);
            obj.SliderHandle.t(obj.SliderCount,1) = ...
                uicontrol('Parent',obj.SliderPanel.Controls,...
                'Style','text',...
                'Units','normalized');
            
            obj.Parameters(obj.SliderCount,1) = ...
                obj.SliderHandle.s(obj.SliderCount).Value;
            
            obj.SliderNameList(obj.SliderCount,1) = cellstr(sName);
            
            updatetext(obj);
        end
        
        % Set all current slider positions
        function obj = setsliderposition(obj)
            width = 0.6;
            height = 1/obj.SliderCount;
            for i = 1:obj.SliderCount
                obj.SliderHandle.s(i,1).Position = ...
                    [1-width 1-height*i width height];
                obj.SliderHandle.t(i,1).Position = ...
                    [0 (1-height*0.3)-height*i 0.35 height];
            end
        end
        
        % Update the text showing current slider values
        function obj = updatetext(obj)
            for i = 1:obj.SliderCount
                name = obj.SliderHandle.s(i).String;
                val = obj.SliderHandle.s(i).Value;
                obj.SliderHandle.t(i).String = [name ': ' num2str(val)];
                obj.SliderHandle.t(i).FontSize = 10;
            end
        end
        
        % Update parameters to be used as model input
        function obj = updateparameters(obj)
            obj.Parameters = zeros(obj.SliderCount,1);
            for i = 1:obj.SliderCount
                obj.Parameters(i,1) = obj.SliderHandle.s(i).Value;
            end
        end
        
        function obj = formatparamlist(obj)
            list = obj.SliderNameList;
            for i = 1:length(list)
                chr = char(list(i,:));
                brackS = find(chr=='[');
                brackE = find(chr==']');
                chr(brackS:brackE) = [];
                list(i,:) = cellstr(chr);
            end
            obj.SliderNameList = list;
        end
        
        % Run model with current parameters
        function obj = solvemodel(obj)
            obj.ParamSetStructure = ...
                setparameterlist(obj.SliderNameList,obj.Parameters);
            [t, state, ~] = calcium_model(obj.ParamSetStructure);
            obj.StateVar(:,1) = t;
            obj.StateVar(:,2) = state.c;
            obj.StateVar(:,3) = state.e;
            obj.StateVar(:,4) = state.m;
            obj.StateVar(:,5) = state.u;

        end
        
        % Update the plots based on current model state
        function obj = updateaxes(obj,~,~)
            
            updatetext(obj);
            updateparameters(obj);
            solvemodel(obj);
            
            % state variables
            t = obj.StateVar(:,1);
            c = obj.StateVar(:,2);
            e = obj.StateVar(:,3);
            m = obj.StateVar(:,4);
            u = obj.StateVar(:,5);
            stateVarList(:,1) = c;
            stateVarList(:,2) = m;
            stateVarList(:,3) = e;
            stateVarList(:,4) = u;
            stateVarName = ["Cytosol","Mitocondria","ER","Microdomain"];
                   
            for iax = 1:4
                ax = obj.Axis.h(1,iax);
                h = plot(t,stateVarList(:,iax),'Parent',ax);
                h.LineWidth = 1.2;
                h.Color = 'b';
                fig = gcf;
                fig.Color = 'w';
                ax.FontWeight = 'bold';
                ax.FontName = 'Times New Roman';
                ax.FontSize = 10;
                legend(ax,stateVarName(iax))
                ax.Title.FontSize = 12;
                ax.AmbientLightColor = 'magenta';
                ax.LineWidth = 1.5;
            end
            
            
            linkaxes(obj.Axis.h, 'x');
        end
    end
end