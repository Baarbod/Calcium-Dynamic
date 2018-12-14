classdef CalciumGUI < handle
    properties
        Figure            % figure handle
        nCompartment      % Number of cell compartments
        Name              % name of gui figure
        SliderPanel       % panel handle that contains ui elements
        ResetButton       % reset button handle
        Axis              % axis handles
        SliderCount       % number of sliders
        SliderHandle      % slider handles
        Parameters        % array of current slider values
        InitialParam      % intial slider values
        State             % array of current state variables
    end
    
    methods
        
        % Constructor
        function obj = CalciumGUI(Name)
            obj.Name = Name;
            obj.SliderCount = 0;
            obj.nCompartment = 4;
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
                'Position',[0.80 0 0.075 0.075],...
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
        
        % Define the initial parameters based on starting slider values
        function obj = initstate(obj)
            obj.InitialParam = obj.Parameters;
            updateaxes(obj);
        end
        
        % Create the axes; Position = [left bottom width height]
        function obj = createplot(obj)
            for iplot = 1:obj.nCompartment
                plotHeight = 1/obj.nCompartment;
                obj.Axis.h(iplot) = axes('Units','normalized',...
                    'Position',...
                    [0.03,(1-plotHeight)-(iplot-1)*plotHeight,0.2,plotHeight]);
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
                    [0 (1-height*0.3)-height*i 0.3 height];
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
        
        % Run model with current parameters
        function obj = solvemodel(obj)
            [t,c,e,m,u] = calcium_model(obj.Parameters);
            obj.State(:,1) = t;
            obj.State(:,2) = c;
            obj.State(:,3) = e;
            obj.State(:,4) = m;
            obj.State(:,5) = u;
        end
        
        % Update the plots based on current model state
        function obj = updateaxes(obj,~,~)
            updateparameters(obj);
            solvemodel(obj);
            updatetext(obj);
            t = obj.State(:,1);
            c = obj.State(:,2);
            e = obj.State(:,3);
            m = obj.State(:,4);
            u = obj.State(:,5);
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
                ax.Title.String = stateVarName(iax);
                ax.Title.FontSize = 12;
                ax.AmbientLightColor = 'magenta';
                ax.LineWidth = 1.5;
            end
            
            linkaxes(obj.Axis.h, 'x');
        end
    end
end