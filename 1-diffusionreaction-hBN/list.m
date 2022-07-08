classdef list <handle    
    %�������������ԣ�һ���������ͷԪ�أ�һ����βԪ�أ���һ��������ĳ���
    properties (GetAccess = public , SetAccess = public )
        head
        tail
        size
    end
    
    methods
        %����һ���յ�����
        function list = list()
            list.size=0;
        end
        
        %�������β�����һ��Ԫ��
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
        
        %�������ͷ�����һ��Ԫ��
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
        
        %�������ͷ��ɾ��һ��Ԫ��
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
        %�������β��ɾ��һ��Ԫ��
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
        
        %����������ѡ��һ����Сֵ����ɾ�����Ԫ��
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
            if ~isempty(minp.Prev) %��ͷ�ڵ�
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
        
        %������ʾ����
        function foredisplay(list)
            p=list.head;
            while ~isempty(p)
                disp(p)
                p=p.Next;
            end
        end
        
        %������ʾ����
        function backdisplay(list)
            p=list.tail;
            while ~isempty(p)
                disp(p)
                p=p.Prev;
            end
        end
    end    
end