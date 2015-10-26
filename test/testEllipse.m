%% will check how many point determine the ellipse

x0=5;
y0=5;
width = 200;
height = 300;
error = 0.01;

% convert to ellipse coordinates
ell_x0 = x0+floor(width/2);
ell_y0 = y0+floor(height/2);
a = floor(width/2);
b = floor(height/2);

ellipse = @(x,y) ((x - ell_x0)/a)^2 + ((y - ell_y0)/b)^2;

x_ellipse = [];
y_ellipse = [];

index = 1;

%first quarter
for i=x0+floor(width/2):x0+width
    for j=y0:(floor(height/2)+y0)
        value = ellipse(i,j);
        if (value >= 1-error) && (value <= 1+error)
            x_ellipse(index) = i;
            y_ellipse(index) = j;
            index=index+1;
        end
    end
end
    
%second quarter
index = numel(x_ellipse)+1;
for i=x0+width:-1:x0+floor(width/2)
    for j=(floor(height/2)+y0):y0+height
        value = ellipse(i,j);
        if (value >= 1-error) && (value <= 1+error)
            x_ellipse(index) = i;
            y_ellipse(index) = j;
            index=index+1;
        end
    end
end
   
%third quarter
index = numel(x_ellipse)+1;
for i=x0+floor(width/2):-1:x0
    for j=y0+height:-1:y0+floor(height/2)
        value = ellipse(i,j);
        if (value >= 1-error) && (value <= 1+error)
            x_ellipse(index) = i;
            y_ellipse(index) = j;
            index=index+1;
        end
    end
end
   
%4th quarter
index = numel(x_ellipse)+1;
for i=x0:x0+floor(width/2)
    for j=y0+floor(height/2):-1:y0
        value = ellipse(i,j);
        if (value >= 1-error) && (value <= 1+error)
            x_ellipse(index) = i;
            y_ellipse(index) = j;
            index=index+1;
        end
    end
end

figure(1);
plot(x_ellipse, y_ellipse, 'r+');
    

    
