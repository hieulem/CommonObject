allgtboxes = [];
for i=1:length(option.recs_class(option.imn).objects)
    % Visualize the mask
    
     if strcmp(option.recs_class(option.imn).objects(i).class, option.cls)
         
        gtboxes = option.recs_class(option.imn).objects(i).bbox;
        rectangle( 'Position', [gtboxes(1),gtboxes(2),gtboxes(3)-gtboxes(1)+1,gtboxes(4)-gtboxes(2)+1], 'LineWidth',4, 'EdgeColor',[0.9,0.3,0.9] );
       allgtboxes  = [allgtboxes ;gtboxes];
     end;
end   