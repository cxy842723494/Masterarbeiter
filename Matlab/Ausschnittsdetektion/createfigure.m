function createfigure(cdata1)
%CREATEFIGURE(cdata1)
%  CDATA1:  image cdata

%  Auto-generated by MATLAB on 30-Aug-2018 16:45:47

% Create figure
figure1 = figure('OuterPosition',[-1927 -7 1936 1096]);

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.0592159545261726 0.0791307893650803 0.880330123796424 0.885608856088561]);
hold(axes1,'on');

% Create image
image(cdata1,'Parent',axes1,'CDataMapping','scaled');

% Create ylabel
ylabel('y');

% Create xlabel
xlabel('x');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.5 1920.5]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0.5 1080.5]);
box(axes1,'on');
axis(axes1,'ij');
% Set the remaining axes properties
set(axes1,'CLim',[4.8680141226151 241.489692043974],'DataAspectRatio',...
    [1 1 1],'Layer','top','TickDir','out');
% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.548143053645117 0.587771613617101 0.333562585969739 0.340887672975767]);
hold(axes2,'on');

% Create image
image(cdata1,'Parent',axes2,'CDataMapping','scaled');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes2,[794.740234118623 806.759765881377]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes2,[396.88965635381 403.61034364619]);
box(axes2,'on');
axis(axes2,'ij');
% Set the remaining axes properties
set(axes2,'CLim',[4.8680141226151 241.489692043974],'DataAspectRatio',...
    [1 1 1],'Layer','top','TickDir','out');
% Create line
annotation(figure1,'line',[0.549518569463549 0.882393397524072],...
    [0.769987699876999 0.768757687576876]);

% Create line
annotation(figure1,'line',[0.722145804676754 0.72283356258597],...
    [0.588175891758918 0.924969249692497],'LineStyle',':');

% Create line
annotation(figure1,'line',[0.694635488308116 0.694635488308116],...
    [0.588175891758918 0.924969249692497]);

% Create ellipse
annotation(figure1,'ellipse',...
    [0.4246989912884 0.627306273062731 0.0120674002751032 0.0209102091020911],...
    'Color',[0 1 0]);

% Create line
annotation(figure1,'line',[0.429347919532325 0.545579006189821],...
    [0.625838280334995 0.580097812930321],'Color',[0 1 0]);

% Create textbox
annotation(figure1,'textbox',...
    [0.708390646492435 0.730342282215218 0.0440973409348029 0.0386454176617809],...
    'Color',[0 0 1],...
    'String',{'1.414'},...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',18);

% Create arrow
annotation(figure1,'arrow',[0.722666825862019 0.695156646352189],...
    [0.717326462235499 0.769988161008322],'Color',[1 0 0]);

% Create line
annotation(figure1,'line',[0.548830811554333 0.88101788170564],...
    [0.718557195571956 0.719557195571956],'LineStyle',':');

% Create line
annotation(figure1,'line',[0.426409903713893 0.52888583218707],...
    [0.647216482164822 0.900369003690037],'Color',[0 1 0]);

% Create textbox
annotation(figure1,'textbox',...
    [0.155774354272418 0.810697918605256 0.0157563022079472 0.0273279347098748],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.328303369769344 0.808710353677386 0.0157563022079588 0.027327934709878],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.241519190058296 0.80871034115311 0.0157563022079586 0.0273279347098783],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.413528379687556 0.808710303580284 0.0157563022079587 0.0273279347098795],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.4992732613175 0.80771646475711 0.0157563022079588 0.0273279347098775],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.156802878997944 0.647147038631318 0.0157563022079596 0.0273279347098819],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.243603680457598 0.645723304056182 0.0157563022079585 0.0273279347098783],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.330387807775427 0.641748124103341 0.0157563022079582 0.027327934709879],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.388590281686665 0.64174809905479 0.0157563022079585 0.0273279347098803],...
    'Color',[0 0 1],...
    'String','1.414',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.501877413855659 0.638766670255195 0.0157563022079579 0.027327934709878],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.158149816960464 0.485421321306571 0.015756302207959 0.0273279347098793],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.244942287898358 0.481611536934222 0.0157563022079585 0.0273279347098792],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.331726506904319 0.479623834239323 0.0157563022079584 0.0273279347098779],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.416432038059941 0.479623834239323 0.0157563022079588 0.0273279347098779],...
    'Color',[0 0 1],...
    'String','2',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.501357725520193 0.481190170213785 0.0157563022079582 0.0273279347098775],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.58554388269966 0.482756355896942 0.0157563022079588 0.027327934709878],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.672847331600425 0.48375018219584 0.0157563022079587 0.0273279347098795],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.759111980155662 0.482756405994043 0.0157563022079595 0.0273279347098796],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.843817511311284 0.481762679889347 0.0157563022079582 0.0273279347098773],...
    'Color',[0 0 1],...
    'String','2',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.157316607604792 0.320969169428694 0.015756302207959 0.027327934709879],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.245164959077482 0.316792373691 0.0157563022079585 0.0273279347098787],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.331429489747977 0.318779926094594 0.0157563022079585 0.0273279347098786],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.391190950075785 0.320767378303986 0.0157563022079584 0.0273279347098803],...
    'Color',[0 0 1],...
    'String','1.414',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.478494713335861 0.320767328206885 0.0157563022079584 0.0273279347098801],...
    'Color',[0 0 1],...
    'String','1.414',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.58762467937705 0.316792624176507 0.0157563022079582 0.0273279347098773],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.674928390243907 0.31877977580329 0.0157563022079591 0.0273279347098802],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.760673507643335 0.318779926094594 0.0157563022079579 0.0273279347098793],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.819915096259412 0.319774052976102 0.015756302207958 0.0273279347098806],...
    'Color',[0 0 1],...
    'String','2.236',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.157858779180197 0.154407328413847 0.0157563022079592 0.0273279347098793],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.245162601382644 0.151820063608594 0.0157563022079586 0.0273279347098785],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.329868119439961 0.150826137115492 0.0157563022079583 0.0273279347098778],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.414573624398973 0.152813739616188 0.0157563022079582 0.0273279347098778],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.501357777913412 0.152813739616188 0.0157563022079583 0.0273279347098778],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.587102738133183 0.151820314094101 0.015756302207958 0.027327934709877],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.673887127417105 0.149832711593405 0.0157563022079581 0.0273279347098772],...
    'Color',[0 0 1],...
    'String','1',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.760151304433375 0.153807465720884 0.015756302207959 0.0273279347098797],...
    'Color',[0 0 1],...
    'String','0',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.819913157710323 0.154801442311087 0.015756302207958 0.0273279347098804],...
    'Color',[0 0 1],...
    'String','1.414',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
