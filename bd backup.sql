PGDMP  ,                     {            coursework aps    16rc1    16rc1 $    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17666    coursework aps    DATABASE     �   CREATE DATABASE "coursework aps" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
     DROP DATABASE "coursework aps";
                postgres    false            �            1259    17696    group_members    TABLE     j   CREATE TABLE public.group_members (
    id integer NOT NULL,
    group_id integer,
    user_id integer
);
 !   DROP TABLE public.group_members;
       public         heap    postgres    false            �            1259    17695    group_members_id_seq    SEQUENCE     �   CREATE SEQUENCE public.group_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.group_members_id_seq;
       public          postgres    false    222            �           0    0    group_members_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.group_members_id_seq OWNED BY public.group_members.id;
          public          postgres    false    221            �            1259    17675    groups    TABLE     �   CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    type character varying(50) NOT NULL
);
    DROP TABLE public.groups;
       public         heap    postgres    false            �            1259    17674    groups_id_seq    SEQUENCE     �   CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.groups_id_seq;
       public          postgres    false    218            �           0    0    groups_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;
          public          postgres    false    217            �            1259    17682    meetings    TABLE     �   CREATE TABLE public.meetings (
    id integer NOT NULL,
    name character varying NOT NULL,
    group_id integer,
    date_time timestamp with time zone
);
    DROP TABLE public.meetings;
       public         heap    postgres    false            �            1259    17681    meetings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.meetings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.meetings_id_seq;
       public          postgres    false    220            �           0    0    meetings_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.meetings_id_seq OWNED BY public.meetings.id;
          public          postgres    false    219            �            1259    17668    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(100) NOT NULL,
    password character varying(256) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    17667    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    216            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    215            ,           2604    17699    group_members id    DEFAULT     t   ALTER TABLE ONLY public.group_members ALTER COLUMN id SET DEFAULT nextval('public.group_members_id_seq'::regclass);
 ?   ALTER TABLE public.group_members ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    222    222            *           2604    17678 	   groups id    DEFAULT     f   ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);
 8   ALTER TABLE public.groups ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217    218            +           2604    17685    meetings id    DEFAULT     j   ALTER TABLE ONLY public.meetings ALTER COLUMN id SET DEFAULT nextval('public.meetings_id_seq'::regclass);
 :   ALTER TABLE public.meetings ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    220    220            )           2604    17671    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215    216            �          0    17696    group_members 
   TABLE DATA           >   COPY public.group_members (id, group_id, user_id) FROM stdin;
    public          postgres    false    222   �&       �          0    17675    groups 
   TABLE DATA           :   COPY public.groups (id, name, password, type) FROM stdin;
    public          postgres    false    218   '       �          0    17682    meetings 
   TABLE DATA           A   COPY public.meetings (id, name, group_id, date_time) FROM stdin;
    public          postgres    false    220   �'       �          0    17668    users 
   TABLE DATA           4   COPY public.users (id, login, password) FROM stdin;
    public          postgres    false    216   �(       �           0    0    group_members_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.group_members_id_seq', 1, false);
          public          postgres    false    221            �           0    0    groups_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.groups_id_seq', 15, true);
          public          postgres    false    217            �           0    0    meetings_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.meetings_id_seq', 43, true);
          public          postgres    false    219            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 3, true);
          public          postgres    false    215            4           2606    17703 0   group_members group_members_group_id_user_id_key 
   CONSTRAINT     x   ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_user_id_key UNIQUE (group_id, user_id);
 Z   ALTER TABLE ONLY public.group_members DROP CONSTRAINT group_members_group_id_user_id_key;
       public            postgres    false    222    222            6           2606    17701     group_members group_members_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.group_members DROP CONSTRAINT group_members_pkey;
       public            postgres    false    222            0           2606    17680    groups groups_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_pkey;
       public            postgres    false    218            2           2606    17689    meetings meetings_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.meetings DROP CONSTRAINT meetings_pkey;
       public            postgres    false    220            .           2606    17673    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    216            7           2606    17690    meetings group_id    FK CONSTRAINT     r   ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT group_id FOREIGN KEY (group_id) REFERENCES public.groups(id);
 ;   ALTER TABLE ONLY public.meetings DROP CONSTRAINT group_id;
       public          postgres    false    218    4656    220            8           2606    17704 )   group_members group_members_group_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);
 S   ALTER TABLE ONLY public.group_members DROP CONSTRAINT group_members_group_id_fkey;
       public          postgres    false    4656    218    222            9           2606    17709 (   group_members group_members_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.group_members DROP CONSTRAINT group_members_user_id_fkey;
       public          postgres    false    4654    222    216            �      x������ � �      �   �   x�UN�n�0<��P�m8:�D��4�T9��cGY��Q���43O���!y�P�$;������T*������w��Q�\��Oh��;0;'|}�8C!�E�l�`#�m�y��|�[~�1A<CZ{���
3bI�0�8��Չq�x�W�ۮ�d�g���|���q�CI%�{JD7�"Ay      �   �   x�mѻN�@��z��(�������h�H�	���ע��m?�:���p`d9ȋz��8eD��y��@����A�
<]�����֚�@Y3/Q��/��c����6mp>]��ZƂT����H���[�����%a�9}~�n)sAh�Rj4Av�L��-�Ӵ�tf��r�)ι����}����R�BTG�$n��=Vo�!%�E	�}W���c�:�(�4���u�!�l�      �   5   x�3�t��˫�L�\F�iE�����˘3,�,9#3��,�,1������ �S�     