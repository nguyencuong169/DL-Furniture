using DLFurniture.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<NewsItem> News { get; set; } = null!;
    public DbSet<Testimonial> Testimonials { get; set; } = null!;
    public DbSet<TeamMember> TeamMembers { get; set; } = null!;
    public DbSet<ServiceItem> Services { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure News table
        modelBuilder.Entity<NewsItem>()
            .ToTable("news")
            .HasKey(n => n.Id);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsId)
            .HasColumnName("news_id")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Titles)
            .HasColumnName("title")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Summary)
            .HasColumnName("summary");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Content)
            .HasColumnName("content");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsImage)
            .HasColumnName("news_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsCategoryId)
            .HasColumnName("news_category_id");


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Tags)
            .HasColumnName("tags")
            .HasMaxLength(2048);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedDate)
            .HasColumnName("updated_date");

        // Configure Testimonials table
        modelBuilder.Entity<Testimonial>()
            .ToTable("testimonials")
            .HasKey(t => t.Id);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Id)
            .HasColumnName("id");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CustomerName)
            .HasColumnName("customer_name")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Location)
            .HasColumnName("location")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Content)
            .HasColumnName("content");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.AvatarImage)
            .HasColumnName("avatar_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Rating)
            .HasColumnName("rating")
            .HasDefaultValue(5);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.UpdatedDate)
            .HasColumnName("updated_date");

        // Configure TeamMembers table
        modelBuilder.Entity<TeamMember>()
            .ToTable("team_members")
            .HasKey(t => t.Id);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Id)
            .HasColumnName("id");

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.FullName)
            .HasColumnName("full_name")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Role)
            .HasColumnName("role")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.AvatarImage)
            .HasColumnName("avatar_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Email)
            .HasColumnName("email")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.FacebookUrl)
            .HasColumnName("facebook_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.TwitterUrl)
            .HasColumnName("twitter_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.InstagramUrl)
            .HasColumnName("instagram_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.PinterestUrl)
            .HasColumnName("pinterest_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.UpdatedDate)
            .HasColumnName("updated_date");

        // Configure Services table
        modelBuilder.Entity<ServiceItem>()
            .ToTable("services")
            .HasKey(s => s.Id);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Id)
            .HasColumnName("id");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Name)
            .HasColumnName("name")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Description)
            .HasColumnName("description");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Image)
            .HasColumnName("image")
            .HasMaxLength(1024);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Category)
            .HasColumnName("category")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.UpdatedDate)
            .HasColumnName("updated_date");
    }
}
