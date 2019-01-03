classdef CalciumGUI < handle
    properties
        Name              % name of gui figure
        hFigure           % figure handle
        nPlot             % Number plots
        hSliderPanel      % panel handle that contains ui elements
        hButtonPanel      % panel handle that contains buttons
        hButton           % vector of all button handles
        nButton           % number of buttons currently active  
        hAxis             % axis handles
        hSlider           % slider handles
        nParam            % number of sliders
        InitialParam      % initial parameter set
        ParamNameList     % list of all parameter names
        ParamValueList    % list of all parameter values
        ParamUnitList     % list of parameter units
        Parameters        % intial slider values
        StateVar          % current state variables
        NonStateVar       % current non-state variables
    end
    
    methods
        
        % Constructor
        function obj = CalciumGUI(Name)
            obj.Name = Name;
            obj.nPlot = 4;
            obj.hFigure = figure('Visible','on','Name',obj.Name);
            movegui(obj.hFigure,'center');
        end
        
        % Panel that will contain parameter sliders
        function createpanel(obj)
            obj.hSliderPanel.Controls = uipanel('Title','Parameter Control',...
                'FontSize',10,'FontWeight','bold','Position',[.80 0 0.20 1]);
        end
        
        % Panel that will contain buttons
        function createbuttonpanel(obj)
            obj.hButtonPanel.Controls = uipanel('Title','Buttons',...
                'FontSize',10,'FontWeight','bold',...
                'Position',[.42 0.02 0.35 0.3]);
        end
        
        % Initialize all parameter properties
        function initparam(obj,P)
            obj.InitialParam = P;
            obj.Parameters = P;
            obj.ParamNameList = fieldnames(obj.Parameters);
            obj.nParam = numel(obj.ParamNameList);
            obj.ParamUnitList = cell(obj.nParam,1);
            obj.ParamValueList = zeros(obj.nParam,1);
            for i = 1:obj.nParam
                obj.ParamValueList(i) = ...
                    obj.Parameters.(obj.ParamNameList{i}).Value;
                obj.ParamUnitList{i,1} = ...
                    obj.Parameters.(obj.ParamNameList{i}).Unit;
            end       
        end
        
        % Setup all GUI components and solve initial system
        function initgui(obj)
            createpanel(obj);
            createbuttonpanel(obj);
            setsliders(obj);
            setsliderposition(obj); 
            obj.nButton = 0;
            addresetbutton(obj);            
            addexportparambutton(obj);            
            addimportparambutton(obj);
            addfluxbutton(obj);
            addbifdiagrambutton(obj);
            setbuttonposition(obj)
            createplot(obj); 
            updateaxes(obj);
        end

        % Create the axes; Position = [left bottom width height]
        function createplot(obj)
            nRow = 3;
            nCol = 2;
            height = 1/nRow-0.04;
            width = 0.8/nCol-0.05;
            iplot = 0;
            for irow = 1:nRow
                for icol = 1:nCol
                    iplot = iplot + 1;
                    if iplot > 5
                        break
                    end
                     obj.hAxis.h(iplot) = axes('Units','normalized',...
                    'Position',...
                    [0.03+1.1*(icol-1)*width 1-1.1*(irow*height) width height]);
                end
            end
            
        end
        
        % Set all the information for all sliders
        function setsliders(obj)
            for i = 1:obj.nParam
                exceptParamList = {'cI','cS','cM','cN'};
                paramName = obj.ParamNameList{i};
                paramValue = obj.ParamValueList(i);
                if ismember(paramName,exceptParamList)
                    sMin = 0;
                    sMax = 1;
                else
                    sMin = 0;
                    sMax = paramValue*2;
                end
                obj.hSlider.s(i,1) = ...
                    uicontrol('Parent',obj.hSliderPanel.Controls,...
                    'Style','slider',...
                    'String',paramName,...
                    'Min',sMin,'Max',sMax,'Value',paramValue,...
                    'SliderStep',[0.01 0.1],...
                    'Units','normalized',...
                    'Callback',@obj.updateaxes);
                obj.hSlider.t(i,1) = ...
                    uicontrol('Parent',obj.hSliderPanel.Controls,...
                    'Style','text',...
                    'Units','normalized');
            end
        end
        
        % Set all slider positions
        function setsliderposition(obj)
            width = 0.6;
            height = 1/obj.nParam;
            for i = 1:obj.nParam
                obj.hSlider.s(i,1).Position = ...
                    [1-width 1-height*i width height];
                obj.hSlider.t(i,1).Position = ...
                    [0 (1-height*0.3)-height*i 0.4 height];
            end
        end
        
        % Update the text showing current slider values
        function updatetext(obj)
            for i = 1:obj.nParam
                name = obj.ParamNameList{i};
                val = obj.hSlider.s(i).Value;
                unit = char(obj.ParamUnitList{i});
                if isempty(unit)
                    sliderText = [name ' ' unit ': ' num2str(val)];
                else
                    sliderText = [name ' [' unit ']: ' num2str(val)];
                end
                obj.hSlider.t(i).String = sliderText;
                obj.hSlider.t(i).FontSize = 10;
            end
        end
        
        % Update parameters to be used as model input
        function updateparameters(obj)
            obj.ParamValueList = zeros(obj.nParam,1);
            for i = 1:obj.nParam
                obj.ParamValueList(i,1) = obj.hSlider.s(i).Value;
                obj.Parameters.(obj.ParamNameList{i}).Value =...
                    obj.hSlider.s(i).Value;
            end
                
        end
        
        % Run model with current parameters
        function solvemodel(obj)
            [t, state, ~] = calcium_model(obj.Parameters);
            
            obj.StateVar(:,1) = t;
            obj.StateVar(:,2) = state.c;
            obj.StateVar(:,3) = state.e;
            obj.StateVar(:,4) = state.m;
            obj.StateVar(:,5) = state.u;
            
        end
        
        % Update the plots based on current model state
        function updateaxes(obj,~,~)
            
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
                ax = obj.hAxis.h(1,iax);
                h = plot(t,stateVarList(:,iax),'Parent',ax);
                h.LineWidth = 1.2;
                h.Color = 'k';
                fig = gcf;
                fig.Color = 'w';
                ax.FontWeight = 'bold';
                ax.FontName = 'Times New Roman';
                ax.FontSize = 10;
%                 legend(ax,stateVarName(iax))
                ax.Title.String = stateVarName(iax);
                ax.Title.FontSize = 12;
                ax.AmbientLightColor = 'magenta';
                ax.LineWidth = 1.5;
            end
            
            % NORMALIZED PLOT HARD CODED
            ax = obj.hAxis.h(1,5);
            time_window = 0.1*t(end);
            tplot = t(t>(t(end) - time_window));
            cplot = c(t>(t(end) - time_window));cplotNORM = cplot/max(cplot);
            eplot = e(t>(t(end) - time_window));eplotNORM = eplot/max(eplot);
            mplot = m(t>(t(end) - time_window));mplotNORM = mplot/max(mplot);
            uplot = u(t>(t(end) - time_window)); uplotNORM = uplot/max(uplot);
            h = plot(tplot,[cplotNORM, eplotNORM, mplotNORM, uplotNORM],'Parent',ax); 
            legend(ax,{'c','e','m','u'})
            h(1).LineWidth = 1.2; 
            h(2).LineWidth = 1.2;
            h(3).LineWidth = 1.2; 
            h(4).LineWidth = 1.2; 
            fig = gcf;
            fig.Color = 'w';
            ax.FontWeight = 'bold';
            ax.FontName = 'Times New Roman';
            ax.FontSize = 10;
            ax.Title.FontSize = 12;
            ax.AmbientLightColor = 'magenta';
            ax.LineWidth = 1.5;
            
            linkaxes(obj.hAxis.h(1:4), 'x');
        end        
                    
        % Button returns the system to it's initial state
        function addresetbutton(obj)
            obj.nButton = obj.nButton + 1;
            obj.hButton.b(obj.nButton) = ...
                uicontrol('Parent',obj.hButtonPanel.Controls,...
                'Style','pushbutton',...
                'String','RESET',...
                'FontSize',10,...
                'Units','normalized',...
                'Callback',@obj.resetgui);
        end
        
        % Callback function for reset button
        function resetgui(obj,~,~)         
            clf
            initparam(obj,obj.InitialParam);
            initgui(obj);
        end
        
        % Button allows user to export current parameter set
        function addexportparambutton(obj)
            obj.nButton = obj.nButton + 1;
            obj.hButton.b(obj.nButton)  = ...
                uicontrol('Parent',obj.hButtonPanel.Controls,...
                'Style','pushbutton',...
                'String','EXPORT',...
                'FontSize',10,...
                'Units','normalized',...
                'Callback',@obj.exportparam);
        end
        
        % Callback function for export button
        function exportparam(obj,~,~)
            ParamSet = obj.Parameters;
            path = uigetdir(pwd,'Select path for output');
            name = char(inputdlg("Enter parameter set name"));
            save([path '\' name],'ParamSet') 
        end
        
        % Button allows user to import a parameter set
        function addimportparambutton(obj)
            obj.nButton = obj.nButton + 1;
            obj.hButton.b(obj.nButton)  = ...
                uicontrol('Parent',obj.hButtonPanel.Controls,...
                'Style','pushbutton',...
                'String','IMPORT',...
                'FontSize',10,...
                'Units','normalized',...
                'Callback',@obj.importparam);
        end
        
        % Callback function for import button
        function importparam(obj,~,~)
            [pSet,path] = uigetfile;
            pset = load([path pSet]);
            fname = char(fieldnames(pset));
            obj.Parameters = pset.(fname);
            for i = 1:obj.nParam
                obj.hSlider.s(i,1).Value = ...
                    obj.Parameters.(obj.ParamNameList{i}).Value;
            end
            
            updateaxes(obj)
        end
        
        % Button displays plot of all channel fluxes 
        function addfluxbutton(obj)
            obj.nButton = obj.nButton + 1;
            obj.hButton.b(obj.nButton)  = ...
                uicontrol('Parent',obj.hButtonPanel.Controls,...
                'Style','pushbutton',...
                'String','FLUX',...
                'FontSize',10,...
                'Units','normalized',...
                'Callback',@obj.showflux);
        end
        
        % Callback function for flux button
        function showflux(obj,~,~)
            [~, ~, ~] = calcium_model(obj.Parameters,...
                '-showfluxplot','-usesubplot');
        end
        
        % Button displays plot of all channel fluxes 
        function addbifdiagrambutton(obj)
            obj.nButton = obj.nButton + 1;
            obj.hButton.b(obj.nButton)  = ...
                uicontrol('Parent',obj.hButtonPanel.Controls,...
                'Style','pushbutton',...
                'String','IP3_BIF_DIAG',...
                'FontSize',10,...
                'Units','normalized',...
                'Callback',@obj.showip3bifdiag);
        end
        
        % Callback function for flux button
        function showip3bifdiag(obj,~,~)
            calcium_model(obj.Parameters,'-showbifdiag');
        end
        
        % Sets position of all buttons
        function setbuttonposition(obj)
            nRow = 3;
            nCol = 4;
            width = 1/nCol;
            height = 1/nRow;
            ibutton = 0;
            for irow = 1:nRow
                for icol = 1:nCol
                    ibutton = ibutton + 1;
                    if ibutton > obj.nButton
                        break
                    end
                    obj.hButton.b(ibutton).Position = ...
                        [(icol-1)*width (nRow-irow)*height... 
                        width height];
                end
            end
            
        end
    end
end