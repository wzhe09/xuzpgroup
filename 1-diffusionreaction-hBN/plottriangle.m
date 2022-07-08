function plottriangle(x,y,r) % equilateral triangle, center and diameter to circle
    triangle_x = [x-r*0.433,x,x+r*0.433,x-r*0.433];
    triangle_y = [y-r*0.25,y+r*0.5,y-r*0.25,y-r*0.25];
    fill(triangle_x,triangle_y,'r'); % 'b'
end