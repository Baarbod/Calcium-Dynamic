classdef CalciumGUI < handle
    properties
        Position          % position of main figure
        Figure            % figure handle
        SliderPanel       % panel handle that contains ui elements
        ResetButton       % reset button handle
        Axis              % axis handles
        SliderCount       % number of sliders
        SliderHandle      % slider handles
        SliderValueList   % array of current slider values
        InitialParam      % intial slider values
        State             % array of current state variables
        Name              % name of gui figure
    end
    
    methods
        
        function obj = CalciumGUI(Name)
            obj.Name = Name;
            obj.SliderCount = 0;
            obj.Figure = figure('Visible','on','Name',obj.Name);
            movegui(obj.Figure,'center');
            obj.SliderPanel.Controls = uipanel('Title','Parameter Control',...
                'FontSize',10,'FontWeight','bold','Position',[.70 0 0.5 1]);
        end
        
        function obj = addresetbutton(obj)
            obj.ResetButton = ...
                uicontrol('Parent',obj.SliderPanel.Controls,...
                'Style','pushbutton',...
                'String','RESET',...
                'FontSize',10,...
                'Units','normalized',...
                'Position',[0 0 0.1 0.1],...
                'Callback',@obj.resetgui);
        end
        
        function obj = resetgui(obj,~,~)
            nVal = length(obj.SliderHandle.s);
            obj.SliderValueList = zeros(nVal,1);
            for i = 1:nVal
                obj.SliderHandle.s(i).Value = obj.InitialParam(i);
            end
            updateaxes(obj);
        end
        
        % intitialize the gui plot
        function obj = initstate(obj)
            obj.InitialParam = obj.SliderValueList;
            updateaxes(obj);
        end
        
        % make the initial axis
        function obj = createplot(obj)
            obj.Axis.h(1) = axes('Units','normalized',...
                'Position',[0.05,0.525,0.275,0.425]);
            obj.Axis.h(2) = axes('Units','normalized',...
                'Position',[0.375,0.525,0.275,0.425]);
            obj.Axis.h(3) = axes('Units','normalized',...
                'Position',[0.05,0.05,0.275,0.425]);
            obj.Axis.h(4) = axes('Units','normalized',...
                'Position',[0.375,0.05,0.275,0.425]);
        end
        
        % add a slider
        function obj = addslider(obj,sName,sMin,sMax,sVal)
            obj.SliderCount = obj.SliderCount + 1;
            width = 0.27;
            height = 1/13;
            obj.SliderHandle.s(obj.SliderCount,1) = ...
                uicontrol('Parent',obj.SliderPanel.Controls,...
                'Style','slider',...
                'String',sName,...
                'Min',sMin,'Max',sMax,'Value',sVal,...
                'SliderStep',[0.01 0.1],...
                'Units','normalized',...
                'Position',[0.3 1-height*obj.SliderCount width height],...
                'Callback',@obj.updateaxes);
            obj.SliderHandle.t(obj.SliderCount,1) = ...
                uicontrol('Parent',obj.SliderPanel.Controls,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0 (1-height*0.3)-height*obj.SliderCount 0.3 height]);
            
            obj.SliderValueList(obj.SliderCount,1) = ...
                obj.SliderHandle.s(obj.SliderCount).Value;
            
            align(obj.SliderHandle.t(:,1),'Center','Fixed')
            updatetext(obj);
        end
        
        function obj = updatetext(obj)
            for i = 1:length(obj.SliderHandle.t)
                name = obj.SliderHandle.s(i).String;
                val = obj.SliderHandle.s(i).Value;
                obj.SliderHandle.t(i).String = [name ': ' num2str(val)];
                obj.SliderHandle.t(i).FontSize = 10;
            end
        end
        
        % update current slider values
        function obj = updateparameters(obj)
            nVal = length(obj.SliderHandle.s);
            obj.SliderValueList = zeros(nVal,1);
            for i = 1:nVal
                obj.SliderValueList(i,1) = obj.SliderHandle.s(i).Value;
            end
        end
        
        % run model
        function obj = solvemodel(obj)
            [t,c,e,m,u] = calcium_model(obj.SliderValueList);
            obj.State(:,1) = t;
            obj.State(:,2) = c;
            obj.State(:,3) = e;
            obj.State(:,4) = m;
            obj.State(:,5) = u;
        end
        
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
%             yAxMax = [2 2 350 350];
%             yTick = [0.25 0.25 50 50];
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
                if iax == 3
                    ax.XAxis.Label.String = 'Time (sec)';
                end
                if iax == 1
                    ax.YAxis.Label.String = '[Ca] \muM';
%                     ax.XTick = [];
                end
%                 if iax == 2
%                     ax.XTick = [];
%                     ax.YTick = [];
%                 end
%                 if iax == 4
%                     ax.YTick = [];
%                 end
%                 ax.YLim = [0 yAxMax(iax)];
%                 ax.YTick = 0:yTick(iax):yAxMax(iax);
            end
            
            linkaxes(obj.Axis.h, 'x');
        end
    end
end