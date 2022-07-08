classdef list <handle    
    %链表有三个属性，一个是链表的头元素，一个是尾元素，另一个是链表的长度
    properties (GetAccess = public , SetAccess = public )
        head
        tail
        size
    end
    
    methods
        %创建一个空的链表
        function list = list()
            list.size=0;
        end
        
        %在链表的尾部添加一个元素
        function insertaftertail(list,node)
            if isempty(list.head)
                list.head=node;
                list.tail=node;
            else
                node.Prev=list.tail;
                list.tail.Next=node;
                list.tail=node;
            end
            list.size=list.size+1;
        end
        
        %在链表的头部添加一个元素
        function insertbeforehead(list,node)
            if isempty(list.head)
                list.head=node;
                list.tail=node;
            else
                node.Next=list.head;
                list.head.Prev=node;
                list.head=node;
            end
            list.size=list.size+1;
        end
        
        %从链表的头部删除一个元素
        function deletefromhead(list)
            if isempty(list.head)
                disp('The linked list is empty\n');
                list.size=0;
                return;
            else
                list.head=list.head.Next;
                list.head.Prev=[];
                list.size=list.size-1;
            end
        end
        %从链表的尾部删除一个元素
        function deletefromtail(list)
            if isempty(list.head)
                disp('The linked list is empty\n');
                list.size=0;
                return;
            else
                list.tail=list.tail.Prev;
                list.tail.Next=[];
                list.size=list.size-1;
            end
        end
        
        %从链表里面选出一个最小值，并删除这个元素
        function minnode=delete_min_node(list) 
            p=list.head.Next;
            minp=list.head;
            while ~isempty(p)
                if(p.Num < minp.Num)
                    minp=p;
                    p=p.Next;
                else
                    p=p.Next;
                end
            end
            if ~isempty(minp.Prev) %非头节点
                minp.Prev.Next=minp.Next;
                minp.Next.Prev=minp.Prev;
                list.size=list.size-1;
            else
                list.head=minp.Next;
                list.head.Prev=[];
                list.size=list.size-1;
            end
            minp.Next=[];
            minp.Prev=[];
            minnode=minp;
        end
        
        %正向显示链表
        function foredisplay(list)
            p=list.head;
            while ~isempty(p)
                disp(p)
                p=p.Next;
            end
        end
        
        %反向显示链表
        function backdisplay(list)
            p=list.tail;
            while ~isempty(p)
                disp(p)
                p=p.Prev;
            end
        end
    end    
end